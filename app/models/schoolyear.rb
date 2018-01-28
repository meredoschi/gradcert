# Where a student is registered
class Schoolyear < ActiveRecord::Base
  # ------------------- References ------------------------

  has_paper_trail

  has_many :registration, dependent: :restrict_with_exception

  # 	belongs_to :band, dependent: :destroy

  belongs_to :program

  # 	validate :valid_program_year, on: :update

  # 	validate :valid_program_year

  # 	validate :approved_not_over_candidates
  #	 validate :grants_requested_not_over_approved_candidates

  # 	validate :grants_requested_not_over_grants

  #
  #    validate :convoked_for_registration_not_over_grants
  #    validate :convoked_for_registration_not_over_grants_requested
  #
  #    validate :grants_not_over_max_capacity
  #    validate :scholarships_within_avaliable_grants
  #    validate :enrollment_not_over_max_capacity
  #

  #    validates_uniqueness_of :programyear, :scope => [:program_id, :schoolterm_id]
  #  To do implement custom validation for parent model

  validates :programyear, presence: true, numericality: { only_integer: true,
                                                          greater_than_or_equal_to: 1,
                                                          less_than_or_equal_to: 5 }

  # TDD - Marcelo - Nov 2017

  def details
    schoolyear_details = ordinalyr + ' '
    schoolyear_details += I18n.t('activerecord.models.schoolyears')
    schoolyear_details += ' [ id : ' + id.to_s + ' ]'
    schoolyear_details
  end

  def info

    sep=Settings.separator_info

    schoolyear_i18n = I18n.t('activerecord.attributes.schoolyears.id').capitalize
    program_i18n = I18n.t('activerecord.attributes.schoolyears.program_id').capitalize
    prog_year_i18n = I18n.t('activerecord.attributes.schoolyears.programyear')
    theory_i18n = I18n.t('activerecord.attributes.schoolyears.theory')
    practice_i18n = I18n.t('activerecord.attributes.schoolyears.practice')

    schoolyear_info=schoolyear_i18n+' [ '+id.to_s+' ]'
    schoolyear_info+=sep+' '+program_i18n+' [ '+program.id.to_s+' ]'
    schoolyear_info+=sep+' '+prog_year_i18n+' [ '+programyear.to_s+' ]'
    schoolyear_info+=sep+' '+theory_i18n+': '+theory.to_s+' '

    schoolyear_info+=sep+' '+practice_i18n+': '+practice.to_s

    schoolyear_info
  end

  # Tested code end

  # [:theory, :practice].each do |h|
  #  	validates h, numericality: { only_integer: true, greater_than_or_equal_to: 0,
  #    less_than_or_equal_to: 8784}, presence: true
  #	end

  # Adapted from registration.rb
  def self.ids_contextual_on(dt)
    @schoolyear_ids_in_context = []

    relevant_terms = Schoolterm.contextual_on(dt)

    relevant_terms.each_with_index do |s, i|
      prog_year = (1 + i).to_i

      schoolyear_ids_in_context_for_the_schoolterm = Schoolyear.for_schoolterm(s)
                                                               .where(programyear: prog_year)

      @schoolyear_ids_in_context << schoolyear_ids_in_context_for_the_schoolterm
    end

    @schoolyear_ids_in_context.flatten
  end

  def self.contextual_on(dt)
    where(id: ids_contextual_on(dt))
  end

  def self.contextual_today
    todays_date = Date.today

    contextual_on(todays_date)
  end

  def self.not_contextual_today
    where.not(id: contextual_today)
  end

  # Alias
  def self.current
    contextual_today
  end

  # Alias, for convenience - not to be confused with present?
  # Use current above to avoid ambiguity
  def self.present
    current
  end

  def self.past
    not_contextual_today
  end

=begin
# ----
  # New fr 2017
  def self.contextual_on(dt)

    joins(:program).merge(Program.contextual_on(dt))

  end

  def self.contextual_today

    joins(:program).merge(Program.contextual_today)

  end

  def self.current

    joins(:program).merge(Program.current)

  end

  # Alias, for convenience - not to be confused with present?
  # Use current above to avoid ambiguity
  def self.present

    self.current

  end

  # i.e. not contextual today (aliased on Program.rb)
  def self.past

    joins(:program).merge(Program.past)

  end

=end

  # ---

  def self.from_institution(i)
    joins(program: :institution).where('institutions.id = ? ', i.id)
  end

  def self.with_institution_id(i)
    joins(program: :institution).where('institutions.id = ? ', i)
  end

  # Used in reports rake task
  def self.with_programname(pn)
    joins(program: :programname).where('programnames.id = ?', pn.id)
  end

  def self.for_schoolterm(s)
    joins(:program).merge(Program.for_schoolterm(s))
  end

  def self.ordered_by_programname_and_year
    joins(program: :programname).order('programnames.name, schoolyears.programyear')
  end

  # Program year ordinal
  def ordinalyr
    programyear.to_s + ordinal_suffix
  end

  def cohort_start
    # hotfix
    I18n.t('cohort') + ': ' + I18n.t('start') + ' ' + I18n.l(program.schoolterm.start)
  end

  def school_term
    program.schoolterm
  end

  def school_term_name
    school_term.name
  end

  # Integer
  def term_start_year
    school_term.start.year
  end

  def year_entered_i18n
    I18n.t('entered_on').capitalize + ' ' + term_start_year.to_s
  end

  def incoming_cohort_i18n
    I18n.t('incoming_cohort') + ' ' + term_start_year.to_s
  end

  # Implemented for Portuguese
  def ordinal_suffix
    @ordinal = ''
    @ordinal = +'º' if I18n.default_locale.to_s[0..2] == 'pt_'

    @ordinal
  end

  def ordinal_year_i18n
    ordinalyr + ' ' + I18n.t('year')
  end

  def program_name
    programyear.to_s + 'º ' + program.program_name
  end

  def program_name_schoolterm
    program_name + ' - ' + I18n.t('start') + ' ' + program.schoolterm.start.year.to_s
  end

  def yr
    program.schoolterm.start.year
  end

  def name_incoming_cohort_i18n
    program_name + ' - ' + I18n.t('incoming_cohort').capitalize + ' ' + yr.to_s
  end

  def program_name_incoming_cohort_program_year
    txt = name_incoming_cohort_i18n

    prog_year = programyear

    if prog_year > 1

      txt += ' - PA' + prog_year.to_s + ' ' + (yr + prog_year - 1).to_s

    end

    txt
  end

  def start_year_i18n
    I18n.t('start') + ' ' + program.schoolterm.start.year.to_s
  end

  # Hotfix
  def program_name_schoolterm_institution
    program_name + ' - ' + start_year_i18n + ' (' + institution + ')'
  end

  def name
    program_name
  end

  def institution
    program.institution.name
  end

  def name_with_institution
    program_name + ' (' + institution + ')'
  end

  # Refer to program.rb
  def program_name_term_institution_short
    program.name_term_institution_short
  end

  def workload
    theory + practice
  end

  def self.for_year(yr)
    where(programyear: yr)
  end

  def self.for_progyear(programid, yr)
    where(program_id: programid, programyear: yr)
  end

  # Used in registration.rb
  def places_available
    program.institution.placesavailable
  end

  def self.for_program_id(programid)
    where(program_id: programid)
  end

  # Takes a numeric argument
  # Refer to: Settings.longest_program_duration
  def self.for_programyear(yr)
    where(programyear: yr)
  end

  # Alias, for convenience
  def self.on_programyear(yr)
    for_programyear(yr)
  end

  # To do: fix argument
  def self.for_program(programid)
    where(program_id: programid)
  end

  # Works for 2 year programs only
  def self.freshman
    where(programyear: 1)
  end

  # Works for 2 year programs only
  def self.senior
    where(programyear: 2)
  end

  def self.veteran
    where.not(id: freshman)
  end

  # Which belong to the next registration season
  # To do: must fix - Schoolterm.allowed.first (to use actual date)
  def self.open
    term = Schoolterm.allowed.first

    #	  joins(:program).where("programs.schoolterm_id = ? ",Schoolterm.allowed.first.id)

    joins(:program).where('programs.schoolterm_id = ? ', 3)
  end

  def full?
    enrollment == maxenrollment
  end

  def first_year?
    programyear == 1
  end

  def self.default_scope
    # this notation prevents ambiguity
    order(programyear: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # 	def self.for_band(band)

  # 		self.where(band_id: band.pluck(:id))

  # 	end

  def grants_requested_not_over_grants
    if grants.present? && grantsrequested.present? && grantsrequested > grants
      errors.add(:grantsrequested, 'excede o número de vagas credenciadas!')
    end
  end

  def approved_not_over_candidates
    if approved.present? && candidates.present? && approved > candidates
      errors.add(:approved, 'excede o número de candidatos!')
    end
  end

  def grants_requested_not_over_approved_candidates
    if programyear == 1 && grantsrequested.present? && approved.present? && grantsrequested > approved
      errors.add(:grantsrequested, 'excede o número de candidatos aprovados!')
    end
  end

  def convoked_for_registration_not_over_grants
    if convokedtoregister.present? && grants.present? && convokedtoregister > scholarships
      errors.add(:convokedtoregister, 'excede o número de bolsas distribuídas!')
    end
  end

  def convoked_for_registration_not_over_grants_requested
    if convokedtoregister.present? && grantsrequested.present? && convokedtoregister > grantsrequested
      errors.add(:convokedtoregister, 'excede o número de bolsas requisitadas!')
    end
  end

  def grants_not_over_max_capacity
    if grants.present? && maxenrollment.present? && grants > maxenrollment
      errors.add(:grants, 'oferecidas excedem o tamanho máximo da turma')
    end
   end

  def scholarships_within_avaliable_grants
    if grants.present? && scholarships.present? && scholarships > grants
      errors.add(:scholarship, 'excedem a quantidade de vagas credenciadas.')
    end
  end

  def enrollment_not_over_max_capacity
    if maxenrollment.present? && enrollment > maxenrollment
      errors.add(:maxenrollment, 'excede a capacidade da turma.')
    end
  end

  # 	def valid_program_year

  #			if (programyear.present? && band.present?)
  #				if (programyear > band.duration || programyear > self.band.numschoolyears)

  #				errors.add(:programyear, "maior que a duração")

  #  		end
  #  	 end
  #	end

  # Useful for querying
  def self.full
    joins(program: :schoolterm).joins(program: :institution)
  end

  # with open registrations, registration season=true
  # To do: must fix - Schoolterm.allowed.first (to use actual date)
  def self.nextterm
    full.where('schoolterms.id = ? ', Schoolterm.allowed.first.id)
  end

  # To do: must fix - Schoolterm.allowed.first (to use actual date)
  # with open registrations, registration season=true
  # To do: distinguish between pap and medres
  def self.currentterm
    full.where('schoolterms.id = ? ', Schoolterm.current.first.id)
  end

  def self.pap_programs
    joins(:program).merge(Program.pap)
    #	 	self.joins(program: :programname).merge(Program.pap).order('programnames.name')
  end

  def self.grants(programid)
    where(program_id: programid).sum(:grants)
  end

  def self.for_users_institution(u)
    joins(:program).where(programs: { institution_id: u.institution_id })
  end

  # show view
  def registrations
    registration
  end

  # show view
  def enrollment
    registration.count
  end

  def self.starting_at(startdate)
    joins(program: :schoolterm).where(schoolterms: { start: startdate })
  end

  # index view
  def self.enrollment
    joins(:registration).count
  end
end
