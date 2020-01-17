# frozen_string_literal: true

# Where a student is registered
class Schoolyear < ActiveRecord::Base
  # ------------------- References ------------------------

  has_paper_trail

  #  ******* Review in progres - January 2020 ********
  #  has_many :registration, dependent: :restrict_with_exception
  belongs_to :program
  #  *************************************************

  #   validate :valid_program_year, on: :update

  #   validate :valid_program_year

  #    validates_uniqueness_of :programyear, :scope => [:program_id, :schoolterm_id]
  #  To do implement custom validation for parent model

  validates :programyear, presence: true, numericality: { only_integer: true,
                                                          greater_than_or_equal_to: 1,
                                                          less_than_or_equal_to: 5 }

  #
  #   # Methods which use the program association
  #
  #   def program_sector
  #     program.sector
  #   end
  #
  #   def sector_i18n
  #     I18n.t('definitions.schoolyear.sector_prefix' + '.' + program_sector)
  #   end
  #
  #   def program_id_i18n
  #     I18n.t('activerecord.attributes.schoolyears.program_id')\
  #         .capitalize + ' [ ' + program.id.to_s + ' ]'
  #   end
  #
  #   # All schoolyears which belong to the program
  #   def program_schoolyears
  #     program.schoolyears
  #   end
  #
  #   def num_program_schoolyears
  #     program_schoolyears.count
  #   end
  #
  #   # Next program year
  #   def nextlevel
  #     program.schoolyears.where(programyear: programyear + 1).first
  #   end
  #
  #   def school_term
  #     program.schoolterm
  #   end
  #
  #   def school_term_name
  #     school_term.name
  #   end
  #
  #   def cohort_start
  #     # hotfix
  #     I18n.t('cohort') + ': ' + I18n.t('start') + ' ' + I18n.l(program.schoolterm.start)
  #   end
  #
  #   def full?
  #     enrollment == program.maxenrollment
  #   end
  #
  #   # ---
  #
  #   def self.from_institution(i)
  #     joins(program: :institution).where('institutions.id = ? ', i.id)
  #   end
  #
  #   def self.with_institution_id(i)
  #     joins(program: :institution).where('institutions.id = ? ', i)
  #   end
  #

  #
  #   def info
  #     sep = Settings.separator_info
  #     identifier_i18n + sep + ' ' + \
  #       program_id_i18n + sep + ' ' + \
  #       programyear_id_i18n + sep + ' ' + \
  #       workload_i18n
  #   end
  #
  #   def name
  #     program_name
  #   end
  #
  #   def program_name
  #     programyear.to_s + ordinal_suffix + ' ' + program.program_name
  #   end
  #
  #

  # Schoolterm
  #
  # Integer
  #
  # def term_start_year
  #   school_term.start.year
  # end
  #
  # def year_entered_i18n
  #   I18n.t('entered_on').capitalize + ' ' + term_start_year.to_s
  # end
  #
  # def incoming_cohort_i18n
  #   I18n.t('incoming_cohort') + ' ' + term_start_year.to_s
  # end
  #

  # 2 Associations oth (Program and schoolterm)
  # def program_name_schoolterm
  #   program_name + ' - ' + I18n.t('start') + ' ' + program.schoolterm.start.year.to_s
  # end
  #
  # def yr
  #   program.schoolterm.start.year
  # end
  #
  # ---
  # def start_year_i18n
  #   I18n.t('start') + ' ' + program.schoolterm.start.year.to_s
  # end
  #

  # 3 Associations (program, schoolterm, institution)
  #
  # Hotfix
  # def program_name_schoolterm_institution
  #   program_name + ' - ' + start_year_i18n + ' (' + institution + ')'
  # end
  #

  #  Reviewed January 2020

  # Implemented for Portuguese
  def ordinal_suffix
    if I18n.default_locale == 'pt_BR'
      'º'
    else ''
    end
  end

  def ordinal_year_i18n
    ordinalyr + ' ' + I18n.t('year')
  end

  # 2018 - TDD

  def identifier_i18n
    I18n.t('activerecord.attributes.schoolyears.id').capitalize + ' [ ' + id.to_s + ' ]'
  end

  def programyear_id_i18n
    I18n.t('activerecord.attributes.schoolyears.programyear')\
        .capitalize + ' [ ' + programyear.to_s + ' ]'
  end

  def theory_i18n
    I18n.t('activerecord.attributes.schoolyears.theory')\
        .capitalize + ': ' + theory.to_s
  end

  def practice_i18n
    I18n.t('activerecord.attributes.schoolyears.practice')\
        .capitalize + ': ' + practice.to_s
  end

  def sep
    Settings.separator_info
  end

  def workload_i18n
    theory_i18n + sep + ' ' + practice_i18n
  end

  # Programyear alias
  def level
    programyear
  end

  # TDD - Marcelo - Nov 2017

  def details
    schoolyear_details = ordinalyr + ' '
    schoolyear_details += I18n.t('activerecord.models.schoolyears')
    schoolyear_details += ' [ id : ' + id.to_s + ' ]'
    schoolyear_details
  end

  # Tested code (specs written afterwards)

  # Program year ordinal
  def ordinalyr
    programyear.to_s + ordinal_suffix
  end

  def first_year?
    programyear == 1
  end

  #  def name_incoming_cohort_i18n
  #    program_name + ' - ' + I18n.t('incoming_cohort').capitalize + ' ' + yr.to_s
  #  end

  def workload
    theory + practice
  end

  #
  # def institution
  #   program.institution.name
  # end
  #
  # def name_with_institution
  #   program_name + ' (' + institution + ')'
  # end
  #
  #   # Refer to program.rb
  #   delegate :name_term_institution_short, to: :program, prefix: true
  #
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
  #   def program_name_incoming_cohort_program_year
  #     schoolyear_program_name_incoming_cohort_program_year = name_incoming_cohort_i18n
  #
  #     if level > 1
  #
  #       schoolyear_program_name_incoming_cohort_program_year += ' - PA' + level.to_s\
  #        + ' ' + (yr + level - 1).to_s
  #
  #     end
  #
  #     schoolyear_program_name_incoming_cohort_program_year
  #   end

  # Tested code end

  # [:theory, :practice].each do |h|
  #    validates h, numericality: { only_integer: true, greater_than_or_equal_to: 0,
  #    less_than_or_equal_to: 8784}, presence: true
  #  end

  #
  # Schoolterms
  #
  #   # Adapted from registration.rb
  #   def self.ids_contextual_on(specified_dt)
  #     @schoolyear_ids_in_context = []
  #
  #     relevant_terms = Schoolterm.contextual_on(specified_dt)
  #
  #     relevant_terms.each_with_index do |s, i|
  #       prog_year = (1 + i).to_i
  #
  #       schoolyear_ids_in_context_for_the_schoolterm = Schoolyear.for_schoolterm(s)
  #                                                                .where(programyear: prog_year)
  #
  #       @schoolyear_ids_in_context << schoolyear_ids_in_context_for_the_schoolterm
  #     end
  #
  #     @schoolyear_ids_in_context.flatten
  #   end
  #
  #   def self.contextual_on(specified_dt)
  #     where(id: ids_contextual_on(specified_dt))
  #   end
  #
  #   def self.contextual_today
  #     todays_date = Time.zone.today
  #
  #     contextual_on(todays_date)
  #   end
  #
  #   def self.not_contextual_today
  #     where.not(id: contextual_today)
  #   end
  #
  #   # Alias
  #   def self.current
  #     contextual_today
  #   end
  #
  #   # Alias, for convenience - not to be confused with present?
  #   # Use current above to avoid ambiguity
  #   def self.present
  #     current
  #   end
  #
  #   def self.past
  #     not_contextual_today
  #   end
  #

  # # ----
  #   # New for 2017
  #   def self.contextual_on(specified_dt)
  #
  #     joins(:program).merge(Program.contextual_on(specified_dt))
  #
  #   end
  #
  #   def self.contextual_today
  #
  #     joins(:program).merge(Program.contextual_today)
  #
  #   end
  #
  #   def self.current
  #
  #     joins(:program).merge(Program.current)
  #
  #   end
  #
  #   # Alias, for convenience - not to be confused with present?
  #   # Use current above to avoid ambiguity
  #   def self.present
  #
  #     self.current
  #
  #   end
  #
  #   # i.e. not contextual today (aliased on Program.rb)
  #   def self.past
  #
  #     joins(:program).merge(Program.past)
  #
  #   end
  #

  # # Used in reports rake task
  # def self.with_programname(programname)
  #   joins(program: :programname).where('programnames.id = ?', programname.id)
  # end
  #
  # def self.for_schoolterm(s)
  #   joins(:program).merge(Program.for_schoolterm(s))
  # end
  #
  # def self.ordered_by_programname_and_year
  #   joins(program: :programname).order('programnames.name, schoolyears.programyear')
  # end
  #
  # Used in reports rake task
  # def self.with_programname(programname)
  #   joins(program: :programname).where('programnames.id = ?', programname.id)
  # end
  #
  # def self.for_schoolterm(s)
  #   joins(:program).merge(Program.for_schoolterm(s))
  # end
  #
  # def self.ordered_by_programname_and_year
  #   joins(program: :programname).order('programnames.name, schoolyears.programyear')
  # end
  #
  # def self.for_progyear(programid, year)
  #   where(program_id: programid, programyear: year)
  # end
  #
  # Used in registration.rb
  # def places_available
  #   program.institution.placesavailable
  # end
  #
  # def self.for_program_id(programid)
  #   where(program_id: programid)
  # end
  #
  # To do: fix argument
  # def self.for_program(programid)
  #   where(program_id: programid)
  # end
  #

  def self.for_programyear(year)
    where(programyear: year)
  end

  # Alias, for convenience
  def self.on_programyear(year)
    for_programyear(year)
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

  # Which belong to the next registration season

  # *******************************************************
  # To do: fix this - to use dates properly
  #  def self.open
  #    joins(:program).where('programs.schoolterm_id = ? ', Schoolterm.allowed.first.id)
  #  end

  #  def self.default_scope
  # this notation prevents ambiguity
  #    order(programyear: :asc)
  # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  #  end

  #   def valid_program_year

  #      if (programyear.present? && num_program_schoolyears > program.duration)
  #
  #        errors.add(:programyear, :exceeds_program_duration)

  #      end
  #  end

  # Useful for querying
  #  def self.full
  #    joins(program: :schoolterm).joins(program: :institution)
  #  end

  # with open registrations, registration season=true
  # To do: must fix - Schoolterm.allowed.first (to use actual date)
  #  def self.nextterm
  #    full.where('schoolterms.id = ? ', Schoolterm.allowed.first.id)
  #  end

  # To do: must fix - Schoolterm.allowed.first (to use actual date)
  # with open registrations, registration season=true
  # To do: distinguish between pap and medres
  #  def self.currentterm
  #    full.where('schoolterms.id = ? ', Schoolterm.current.first.id)
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
