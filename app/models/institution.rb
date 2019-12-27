# frozen_string_literal: true

# Last revised: December 2019
class Institution < ActiveRecord::Base
  # --- custom validations
  # --- http://guides.rubyonrails.org/active_record_validations.html

  #  include ActiveModel::Validations
  #   validates_with CustomValidation::NoDigits
  #   validates_with CustomValidation::AllCharacters

  # ----

  before_validation :squish_whitespaces

  [:institutiontype_id].each do |ids|
    validates ids, presence: true
  end

  has_paper_trail

  belongs_to :institutiontype

  has_many  :characteristic, foreign_key: 'institution_id'
  has_many  :college, foreign_key: 'institution_id'
  has_many  :healthcareinfo, foreign_key: 'institution_id'
  has_many  :placesavailable, foreign_key: 'institution_id'
  has_many  :program, foreign_key: 'institution_id'
  has_many  :researchcenter, foreign_key: 'institution_id'
  has_many  :roster, foreign_key: 'institution_id'
  has_many  :user, foreign_key: 'institution_id', dependent: :restrict_with_exception

  has_one :accreditation
  accepts_nested_attributes_for :accreditation

  has_one :address
  accepts_nested_attributes_for :address

  has_one :phone
  accepts_nested_attributes_for :phone

  has_one :webinfo
  accepts_nested_attributes_for :webinfo

  scope :paulista, -> { joins(:stateregion).merge(Stateregion.paulista).order(:name) }

  #   validates :url, length:  { maximum: 150 }
  validates :name, presence: true, length: { maximum: 250 }

  validates :abbreviation, length: { maximum: 20 }

  # https://stackoverflow.com/questions/690664/rails-validates-uniqueness-of-case-sensitivity
  validates :name, uniqueness: { case_sensitive: false }

  # validates :legacycode, numericality: { only_integer: true,
  #   greater_than_or_equal_to: 0, less_than_or_equal_to: 999}

  validate :abbreviation_without_special_characters

  # Institutions with registrations (active or otherwise)
  def self.with_registrations
    where(id: Registration.institution_ids)
  end

  # For payroll absences report (see: AbsentreportsController)
  def self.annotated_on_payroll(specified_payroll)
    payroll_registrations = Registration.regular_within_payroll_context(specified_payroll)
                                        .joins(student: [contact: { user: :institution }])
                                        .joins(:annotation)

    institution_ids = payroll_registrations.pluck('institutions.id').uniq.sort

    institution_ids
  end

  def abbreviation_without_special_characters
    (return if (abbreviation =~ /[\W]/).nil?)
    errors.add(:abbreviation, :may_not_contain_special_characters)
  end

  # New for 2017
  def abbrv
    max_len = Settings.max_length_for_institution_abbreviation # default is 65

    (return abbreviation.upcase if abbreviation.present?)

    Pretty.initialcaps(name[0..max_len])
  end

  # --------------
  # Enrollment on a particular schoolterm - returns an active record relation
  def schoolterm_enrollment_list(schterm)
    Registration.on_schoolterm(schterm).from_institution(self)
  end

  # Enrollment on a particular schoolterm
  def schoolterm_enrollment(schterm)
    schoolterm_enrollment_list(schterm).count
  end

  # i.e. Number of *confirmed* cancellations ("deactivations")  Suspension not currently used.
  def schoolterm_inactive_registrations_list(schterm)
    schoolterm_enrollment_list(schterm).inactive.confirmed
  end

  # i.e. Number of *confirmed* cancellations ("deactivations")  Suspension not currently used.
  def schoolterm_inactive_registrations(schterm)
    schoolterm_inactive_registrations_list(schterm).count
  end

  # Alias, convenience
  def num_schoolterm_inactive_registrations(schterm)
    schoolterm_inactive_registrations(schterm)
  end

  def schoolterm_quota_info(schterm)
    Placesavailable.for_institution_on_schoolterm(self, schterm)
    #    Registration.schoolyear.program.institution.placesavailable.first.authorized
  end

  def schoolterm_authorized_quota(schterm)
    schoolterm_quota_info(schterm).first.authorized
  end

  def remaining_vacancies_on_schoolterm(schterm)
    schoolterm_authorized_quota(schterm) \
    - schoolterm_enrollment(schterm) \
     + schoolterm_inactive_registrations(schterm)
  end

  def enrollment_reached_maximum_on_schoolterm?(schterm)
    remaining_vacancies_on_schoolterm(schterm).zero?
  end

  # Enrollment control
  def self.with_contacts
    joins(user: :contact).uniq.order(:name)
  end

  def self.default_scope
    order(name: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # Used on statements
  def self.ordered_by_name
    order(name: :asc) # this notation prevents ambiguity
  end

  scope :provisional, -> { where(provisional: true) }

  scope :registered, -> { where(provisional: false) }

  scope :with_programs, -> { joins(:program).uniq.order(:name) }

  scope :with_pap_programs, -> {
                              joins(:program).uniq
                                             .where(programs: { pap: true })
                                             .order(:name)
                            }

  scope :with_medres_programs, -> {
                                 joins(:program).uniq
                                                .where(programs: { medres: true })
                                                .order(:name)
                               }

  scope :researchcenter, -> { joins(:researchcenter) }
  scope :college, -> { joins(:college) }
  scope :healthcareinfo, -> { joins(:healthcareinfo) }

  scope :for_user, ->(user) {
    where(id: user.institution_id)
  }

  def self.with_active_programs
    joins(:program).merge(Program.active)
  end

  def self.pap
    joins(:program).merge(Program.pap)
  end

  def self.undergraduate
    where(undergraduate: true)
  end

  def self.medres
    joins(:program).merge(Program.medres)
  end

  def self.gradcert
    joins(:program).merge(Program.gradcert)
  end

  def self.with_users
    joins(:user).uniq
  end

  def self.with_users_seen_by_readonly
    with_users.merge(User.visible_to_readonly)
  end

  def self.with_pap_users
    joins(:user).merge(User.pap)
  end

  def with_healthcare_info?
    healthcareinfo.exists?
  end

  def with_research_center?
    researchcenter.exists?
  end

  def with_college?
    college.exists?
  end

  def with_programs?
    program.exists?
  end

  def with_active_programs?
    program.active.exists?
  end

  def with_characteristic?
    characteristic.exists?
  end

  def self.with_medres_users
    Institution.joins(:user).merge(User.medres)
  end

  def self.with_characteristic
    joins(:characteristic).order(:name)
  end

  def self.without_healthcareinfo
    where.not(id: with_healthcareinfo)
  end

  def self.without_characteristic
    where.not(id: with_characteristic)
  end

  def self.with_healthcareinfo
    joins(:healthcareinfo).order(:name)
  end

  def self.with_college
    joins(:college).order(:name)
  end

  def self.without_researchcenter
    where.not(id: researchcenter)
  end

  def self.without_college
    where.not(id: with_college)
  end

  def with_infrastructure?
    if with_research_center? || with_college? || with_healthcare_info?

      true

    else

      false

    end
  end

  def with_pap_programs?
    program.pap.count.positive?
  end

  def higherlearning?
    if undergraduate || with_pap_programs? || with_medres_programs? || with_gradcert_programs?

      true

    else

      false

    end
  end

  def with_gradcert_programs?
    program.gradcert.count.positive?
  end

  def with_medres_programs?
    program.medres.count.positive?
  end

  def programs
    program
  end

  protected

  def squish_whitespaces
    (return unless !name.nil? && !abbreviation.nil?)

    [name, abbreviation].each(&:squish)
  end
end
