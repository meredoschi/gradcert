# A contact with the student role
class Student < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :contact
  belongs_to :profession

  has_many :registration, dependent: :restrict_with_exception

  has_one :bankaccount
  accepts_nested_attributes_for :bankaccount

  has_many :diploma, dependent: :destroy
  accepts_nested_attributes_for :diploma, allow_destroy: true

  validates :profession_id, presence: true

  # 2017 registration season hotfix
  validates_uniqueness_of :contact_id

  #	[:contact_id, :profession_id].each do |required_field|

  [:contact_id].each do |required_field|
    validates required_field, presence: true
  end

  scope :previousparticipant, -> { where(previousparticipant: true) }

  scope :nationalhealthcareworker, -> { where(nationalhealthcareworker: true) }

  scope :not_previousparticipant, -> { where(previousparticipant: false) }

  scope :not_nationalhealthcareworker, -> { where(nationalhealthcareworker: false) }

  # http://stackoverflow.com/questions/20914899/rails-validate-uniqueness-only-if-conditional
  # 	validates :councilmembership, presence: true, if: 'council_id.present?'
  #  validates :councilmembership, absence: true, if: 'council_id.nil?'

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  has_paper_trail

  # 2018 hotfix
  def self.pipeline
    registered_students = joins(:registration)
    registered_student_ids = registered_students.pluck(:student_id)
    season_debut = Schoolterm.latest.seasondebut
    where.not(id: registered_student_ids).where('students.created_at > ? ', season_debut)
  end

  def self.with_statements_in_calendar_year(yr)
    where(id: Registration.with_statements_in_calendar_year(yr).student_ids)
  end
  # -- 2018

  # Barred from registering
  def self.not_barred
    not_previousparticipant.not_nationalhealthcareworker
  end

  # Senior students - i.e. PA2
  def self.veteran
    joins(registration: :schoolyear).merge(Schoolyear.senior)
  end

  def self.not_veteran
    where.not(id: veteran)
  end

  def self.default_scope
    Student.joins(:contact).order('contacts.name')
  end

  def bankaccount_verificationdigit
    bankaccount.verificationdigit
  end

  def bankaccount_num
    bankaccount.num
  end

  def bankbranch_verificationdigit
    bankaccount.bankbranch.verificationdigit
  end

  def bankbranch_num
    bankaccount.bankbranch.code
  end

  # Alias
  def bankbranch_code
    bankbranch_num
  end

  def bankbranch_state
    bankaccount.bankbranch.address.municipality.stateregion.state.abbreviation
  end

  def bankbranch_municipality
    bankaccount.bankbranch.address.municipality.name
  end

  def bankbranch_location
    bankbranch_municipality + ' - ' + bankbranch_state
  end

  def contact_name
    contact.name
  end

  # 	def council_name

  # 			self.council.name

  # 	end

  # 	def council_abbreviation

  # 		self.council.abbreviation

  # 	end

  def profession_name
    profession.name
  end

  def institution_name
    contact.user.institution.name
  end

  def institution_contact_name
    contact.name + ' (' + contact.user.institution.name + ')'
  end

  def self.from_institution(i)
    joins(:contact).merge(Contact.from_institution(i))
  end

  def self.from_own_institution(user)
    joins(:contact).merge(Contact.from_own_institution(user))
  end

  def institution_id
    contact.user.institution_id
  end

  def self.registered
    joins(:registration)
  end

  def self.registerable_at_users_institution(u)
    from_own_institution(u).not_registered
  end

  def self.not_registered
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: registered)
  end

  def self.available_for_registration
    not_registered.count
  end

  def namecpf
    contact_name + ' (' + cpf + ')'
  end

  def cpf
    contact.personalinfo.tin
  end

  def self.pap
    joins(contact: :user).merge(User.pap)
  end

  # For 2017 registrations
  def registered?
    registration.present?
  end

  def self.called(fullname)
    joins(:contact).merge(Contact.called(fullname))
  end

  # To do: fix - Schoolterm.allowed.first (to use actual date)
  def self.not_incoming
    joins(registration: { schoolyear: :program })
      .where('programs.schoolterm_id<>?', Schoolterm.allowed.first.id)
  end

  # New for 2017 - Ability
  def self.veterans_today
    veterans_today_ids = Registration.contextual_today.veterans.pluck(:student_id)

    where(id: veterans_today_ids)
  end

  # New for 2017 - Ability
  def self.todays_repeats
    todays_repeat_registration_ids = Registration.contextual_today.repeat.pluck(:student_id)

    where(id: todays_repeat_registration_ids)
  end

  # Alias, for convenience
  def self.repeat_registration
    todays_repeats
  end

  # New for 2017 - Ability
  # To do for 2018 - Refine this to exclude makeups already completed.
  def self.makeup
    makeup_registration_ids = Registration.makeup.pluck(:student_id)

    where(id: makeup_registration_ids)
  end

  # Alias, for convenience
  def self.makeup_registration
    makeup
  end

  def self.incoming
    where.not(id: not_incoming)
  end

  def id_i18n
    I18n.t('activerecord.attributes.student.id') + ': ' + id.to_s
  end

  def details
    contact.name + ' (' + id_i18n + ') | ' + profession.name + ' | ' + contact.user.institution.name
  end
end
