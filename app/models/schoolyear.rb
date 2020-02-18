# frozen_string_literal: true

# Where a student is registered
class Schoolyear < ActiveRecord::Base
  # ------------------- References ------------------------

  has_paper_trail

  #  ******* Review in progres - February 2020 ********
  #  has_many :registration, dependent: :restrict_with_exception
  belongs_to :program

  scope :ordered_by_programname_and_year, -> {
                                            joins(program: :programname)
                                              .unscoped
                                              .order('programnames.name,schoolyears.programyear')
                                          }

  #  *************************************************

  validate :valid_program_year

  #  validate :valid_program_year, on: :update

  validates :programyear, presence: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 1,
                                          less_than_or_equal_to: Program::MAX_YEARS }

  #  Reviewed January 2020

  ## Class methods

  # e.g. First year, second, third, fourth, fifth training year (e.g. medical residency programs)
  def self.level(year)
    where(programyear: year)
  end

  # Alias, for convenience
  def self.on_programyear(year)
    level(year)
  end

  def self.freshman
    where(programyear: 1)
  end

  def self.veteran
    where.not(id: freshman)
  end

  def self.senior
    most_senior_programyear_offered = pluck(:programyear).max.to_i
    where(programyear: most_senior_programyear_offered) if most_senior_programyear_offered > 1
  end

  ## Instance methods

  #    All schoolyears which belong to the program
  delegate :schoolyears, to: :program, prefix: true

  delegate :sector, to: :program, prefix: true

  def details
    schoolyear_details = ordinalyr + ' '
    schoolyear_details += I18n.t('activerecord.models.schoolyears')
    schoolyear_details += ' [ id : ' + id.to_s + ' ]'
    schoolyear_details
  end

  def first_year?
    programyear == 1
  end

  def identifier_i18n
    I18n.t('activerecord.attributes.schoolyears.id').capitalize + ' [ ' + id.to_s + ' ]'
  end

  def info
    sep = Pretty.sep
    identifier_i18n + sep + ' ' + \
      program_id_i18n + sep + ' ' + \
      programyear_id_i18n + sep + ' ' + \
      workload_i18n
  end

  def level
    programyear
  end

  def name
    program_name
  end

  def ordinal_year_i18n
    ordinalyr + ' ' + I18n.t('year')
  end

  def ordinalyr
    programyear.to_s + Pretty.ordinal_suffix
  end

  def num_program_schoolyears
    program_schoolyears.count
  end

  # The next grade level
  def nxtlevel
    program.schoolyears.find_by programyear: programyear + 1
  end

  def practice_i18n
    I18n.t('activerecord.attributes.schoolyears.practice')\
        .capitalize + ': ' + practice.to_s
  end

  def program_id_i18n
    I18n.t('activerecord.attributes.schoolyears.program_id')\
        .capitalize + ' [ ' + program.id.to_s + ' ]'
  end

  def program_name
    programyear.to_s + Pretty.ordinal_suffix + ' ' + program.name
  end

  def programyear_id_i18n
    I18n.t('activerecord.attributes.schoolyears.programyear')\
        .capitalize + ' [ ' + programyear.to_s + ' ]'
  end

  def theory_i18n
    I18n.t('activerecord.attributes.schoolyears.theory')\
        .capitalize + ': ' + theory.to_s
  end

  def workload_i18n
    theory_i18n + Pretty.sep + ' ' + practice_i18n
  end

  def workload
    theory + practice
  end

  def sector_i18n
    I18n.t('definitions.schoolyear.sector_prefix' + '.' + program_sector)
  end

  ## January 2020 reviewed methods above

  def name_incoming_cohort_i18n
    program_name + ' - ' + I18n.t('incoming_cohort').capitalize + ' ' + yr.to_s
  end

  def school_term
    program.schoolterm
  end

  delegate :name, to: :school_term, prefix: true

  def cohort_start
    # hotfix
    I18n.t('cohort') + ': ' + I18n.t('start') + ' ' + I18n.l(program.schoolterm.start)
  end

  #   # From early development (functionality not implemented)
  #   def full?
  #     enrollment == program.maxenrollment
  #   end

  # Schoolyears (program course offerings) by the specified institution
  def self.from_institution(institution)
    joins(program: :institution).where('institutions.id = ? ', institution.id)
  end

  def term_start_year
    school_term.start.year
  end

  def year_entered_i18n
    I18n.t('entered_on').capitalize + ' ' + term_start_year.to_s
  end

  def incoming_cohort_i18n
    I18n.t('incoming_cohort') + ' ' + term_start_year.to_s
  end

  # 2 Associations oth (Program and schoolterm)
  def program_name_schoolterm
    program_name + ' - ' + I18n.t('start') + ' ' + program.schoolterm.start.year.to_s
  end

  def yr
    program.schoolterm.start.year
  end

  #
  # ---
  def start_year_i18n
    I18n.t('start') + ' ' + term_start_year.to_s
  end

  # 3 Associations (program, schoolterm, institution)
  #
  # Hotfix
  def program_name_schoolterm_institution
    program_name + ' - ' + start_year_i18n + ' (' + institution + ')'
  end

  def institution
    program.institution.name
  end

  def name_with_institution
    program_name + ' (' + institution + ')'
  end

  delegate :name_term_institution_short, to: :program, prefix: true

  #    Refer to program.rb
  delegate :name_term_institution_short, to: :program, prefix: true

  #   # show view
  #   def registrations
  #     registration
  #   end
  #
  #   # show view
  #   def enrollment
  #     registration.count
  #   end
  #
  def program_name_incoming_cohort_program_year
    area_abbreviation = I18n.t('activerecord.attributes.program.virtual.abbreviation.pap')

    txt = name_incoming_cohort_i18n

    txt += ' - ' + area_abbreviation + level.to_s + ' ' + (yr + level - 1).to_s if level > 1

    txt
  end
  %i[theory practice].each do |instruction_hours|
    validates instruction_hours, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                                 less_than_or_equal_to: 8784 }, presence: true
  end

  #
  # Schoolterms
  #

  # Sql version, less portable but faster
  def self.ids_contextual_on(specified_dt)
    query = "with Intervals_CTE AS (select s.id, ((s.programyear-1)::VARCHAR || ' year')"\
    '::interval as intervl, s.program_id, s.programyear,t.start, t.finish from schoolyears s, '\
    'programs p, schoolterms t where s.program_id=p.id and p.schoolterm_id=t.id) '\
    ', '\
    'Schoolyear_CTE AS (select i.id, (i.start+i.intervl)::date as start, '\
    "                  (i.start+i.intervl+interval '1 year'-interval '1 day')::date as finish "\
    'from Intervals_CTE i) '\
    'select id from Schoolyear_CTE where start <= ? AND finish >= ? '

    find_by_sql [query, specified_dt, specified_dt]
  end

  # Sql version, less portable but faster
  def self.contextual_on(specified_dt)
    where(id: Schoolyear.ids_contextual_on(specified_dt))
  end

  def self.contextual_today
    todays_date = Time.zone.today

    contextual_on(todays_date)
  end

  def self.not_contextual_today
    where.not(id: contextual_today)
  end

  #    Alias
  def self.current
    contextual_today
  end

  #    Alias, for convenience - not to be confused with present?
  #    Use current above to avoid ambiguity
  def self.present
    current
  end

  # Used in reports rake task
  def self.with_programname(programname)
    joins(program: :programname).where('programnames.id = ?', programname.id)
  end

  def self.for_schoolterm(schoolterm)
    joins(:program).merge(Program.for_schoolterm(schoolterm))
  end

  def self.ordered_by_programname_and_year
    joins(program: :programname).order('programnames.name, schoolyears.programyear')
  end

  def self.for_progyear(programid, year)
    where(program_id: programid, programyear: year)
  end

  # Used in registration.rb
  def places_available
    program.institution.placesavailable
  end
  #
  # To do: fix argument
  # def self.for_program(programid)
  #   where(program_id: programid)
  # end
  #

  def self.default_scope
    # this notation prevents ambiguity
    order(programyear: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  def valid_program_year
    if programyear.present? && program.present? && program.duration.present? \
      && programyear > program.duration

      errors.add(:programyear, :exceeds_program_duration)
    end
  end

  # Useful for querying
  def self.full
    joins(program: :schoolterm).joins(program: :institution)
  end

  def self.open
    joins(:program).merge(Program.open)
  end

  # with open registrations, registration season=true
  # To do: must fix - Schoolterm.allowed.first (to use actual date)
  #  def self.nextterm
  #    full.where('schoolterms.id = ? ', Schoolterm.allowed.first.id)
  #  end

  #  def self.pap_programs
  #    joins(:program).merge(Program.pap)
  #     self.joins(program: :programname).merge(Program.pap).order('programnames.name')
  #  end

  #  def self.grants(programid)
  #    where(program_id: programid).sum(:grants)
  #  end

  #  def self.for_users_institution(u)
  #    joins(:program).where(programs: { institution_id: u.institution_id })
  #  end

  #  def self.starting_at(startdate)
  #    joins(program: :schoolterm).where(schoolterms: { start: startdate })
  #  end

  # index view
  #  def self.enrollment
  #    joins(:registration).count
  #  end
end
