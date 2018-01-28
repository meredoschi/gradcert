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

  belongs_to :municipality

  belongs_to :streetname

  belongs_to :institutiontype

  has_many  :roster, foreign_key: 'institution_id'

  has_many  :characteristic, foreign_key: 'institution_id'

  has_many  :researchcenter, foreign_key: 'institution_id'

  has_many  :healthcareinfo, foreign_key: 'institution_id'

  has_many  :college, foreign_key: 'institution_id'

  has_many  :program, foreign_key: 'institution_id'

  has_many  :user, foreign_key: 'institution_id'

  has_many  :user, dependent: :restrict_with_exception

  has_many  :placesavailable, foreign_key: 'institution_id'

  has_one :address
  accepts_nested_attributes_for :address

  has_one :phone
  accepts_nested_attributes_for :phone

  has_one :webinfo
  accepts_nested_attributes_for :webinfo

  has_one :accreditation
  accepts_nested_attributes_for :accreditation

  belongs_to :user, foreign_key: 'user_id'

  #  belongs_to :clericalunit

  scope :paulista, -> { joins(:stateregion).merge(Stateregion.paulista).order(:name) }

  #   validates :url, length:  { maximum: 150 }
  validates :name, presence: true, length: { maximum: 250 }

  validates :abbreviation, length: { maximum: 20 }

  #   validates :abbreviation, format: { without: /([\W])/, message: I18n.t('activerecord.errors.models.institution.attributes.abbreviation.may_not_contain_special_characters')}

  validates_uniqueness_of :name

  # 	validates :legacycode, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 999}

  has_many :users, foreign_key: 'institution_id'

# To do: review this validation
#  validate :abbreviation_without_special_characters

  # Institutions with registrations (active or otherwise)
  def self.with_registrations
    where(id: Registration.institution_ids)
  end

  # For payroll absences report (see: AbsentreportsController)
  def self.annotated_on_payroll(p)
    payroll_registrations = Registration.regular_within_payroll_context(p).joins(student: [contact: { user: :institution }]).joins(:annotation)

    institution_ids = payroll_registrations.pluck('institutions.id').uniq.sort

    institution_ids
  end

  def abbreviation_without_special_characters
    unless	(abbreviation =~ /[\W]/).nil?
      errors.add(:abbreviation, :may_not_contain_special_characters)
    end
  end

  # New for 2017
  def abbrv
    max_len = 65

    if abbreviation.present?

      return abbreviation.upcase

    else

      return Pretty.initialcaps(name[0..max_len])

    end
  end

  # --------------
  # Enrollment on a particular schoolterm
  def schoolterm_enrollment(s)
    Registration.on_schoolterm(s).from_institution(self).count
  end

  # i.e. *confirmed* cancellations ("deactivations")  Suspension not currently used.
  def schoolterm_inactive_registrations(s)
    Registration.on_schoolterm(s).from_institution(self).inactive.confirmed.count
  end

  def schoolterm_quota_info(s)
    Placesavailable.for_institution_on_schoolterm(self, s)
    #    Registration.schoolyear.program.institution.placesavailable.first.authorized
  end

  def schoolterm_authorized_quota(s)
    schoolterm_quota_info(s).first.authorized
  end

  def remaining_vacancies_on_schoolterm(s)
    #      return self.schoolterm_authorized_quota(s)-self.schoolterm_enrollment(s)

    schoolterm_authorized_quota(s) - schoolterm_enrollment(s) + schoolterm_inactive_registrations(s)
  end

  def enrollment_reached_maximum_on_schoolterm?(s)
    remaining_vacancies_on_schoolterm(s) == 0
  end

  # Enrollment control
  def self.with_contacts
    joins(users: :contact).uniq.order(:name)
  end

  def user_contact_name
    user.contact.name
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

  scope :with_pap_programs, -> { joins(:program).uniq.where(programs: { pap: true }).order(:name) }

  scope :with_medres_programs, -> { joins(:program).uniq.where(programs: { medres: true }).order(:name) }

  scope :researchcenter, -> { joins(:researchcenter) }
  scope :college, -> { joins(:college) }
  scope :healthcareinfo, -> { joins(:healthcareinfo) }

  scope :for_user, lambda { |user|
    where(id: user.institution_id)
  }

  def self.with_active_programs
    joins(:program).merge(Program.active)
  end

  def site_URL_is_clean
    errors.add(:url, :entered_incorrectly) if url =~ %r{\Ahttps?://}
  end

  def self.pap
    where(pap: true)
  end

  def self.undergraduate
    where(undergraduate: true)
  end

  def self.medres
    where(medres: true)
  end

  def self.with_users
    joins(:users).uniq
  end

  def self.with_users_seen_by_readonly
    joins(:users).merge(User.visible_to_readonly)
  end

  def self.with_pap_users
    joins(:users).merge(User.pap)
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
    Institution.joins(:users).merge(User.medres)
  end

  # http://stackoverflow.com/questions/3784394/rails-3-combine-two-variables
  def fulladdress
    [streetname.designation, address, addresscomplement].join(' ')
    # [address, addresscomplement].join(" ")
  end

  def trail_originator
    User.find(originator) if originator
  end

  # 	def municipality_name

  # 			self.address.municipality.name

  # 	end

  def contact_name
    user.contact.name
  end

  def city
    address.municipality.name
  end

  def self.are_registered_supervisors
    joins(:supervisor)
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

  def self.regional
    joins(address: { municipality: :regionaloffice })
  end

  def with_infrastructure?
    if with_research_center? || with_college? || with_healthcare_info?

      true

    else

      false

    end
  end

  def with_pap_programs?
    if program.pap.count > 0

      true

    else

      false

    end
  end

  def higherlearning?
    if undergraduate || with_pap_programs? || with_medres_programs?

      true

    else

      false

    end
  end

  def with_medres_programs?
    if program.medres.count > 0

      true

    else

      false

    end
  end

  def programs
    program
  end

  protected

  def squish_whitespaces
    if !name.nil? && !abbreviation.nil?

      [name, abbreviation].each do |txt|
        txt = txt.squish
      end

    end
  end
end
