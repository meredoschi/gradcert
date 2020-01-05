# All system users must have a respective contact object by design
class Contact < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'

  # 	before_validation :squish_whitespaces

  has_paper_trail

  mount_uploader :image, ImageUploader # Carrierwave, photo uploads

  validates :name, presence: true, length: { maximum: 200 }
  validates_uniqueness_of :name, scope: [:address_id]

  validates :role_id, presence: true

  # 	validates :name, format: { with: /[A-Z]+/, message: I18n.t('only_letters_allowed') }

  # https://pt.wikipedia.org/wiki/Cadastro_de_Pessoas_F%C3%ADsicas

  # Primeiro digito verificador do CPF

  # Tests written - Marcelo - March 2018

  belongs_to :role

  belongs_to :student

  belongs_to :user, dependent: :delete

  has_many  :assesment, foreign_key: 'contact_id'

  has_many  :supervisor, foreign_key: 'contact_id'
  has_many  :student, foreign_key: 'contact_id'

  has_one :address, foreign_key: 'contact_id'
  accepts_nested_attributes_for :address

  has_one :phone, foreign_key: 'contact_id'
  accepts_nested_attributes_for :phone

  has_one :webinfo, foreign_key: 'contact_id'
  accepts_nested_attributes_for :webinfo

  has_one :personalinfo, foreign_key: 'contact_id'
  accepts_nested_attributes_for :personalinfo

  def tin
    personalinfo.tin
  end

  # Alias, for convenience (in Brazil)
  def cpf
    tin
  end

  def birth
    personalinfo.birth
  end

  def name_birth
    name + ' [' + birth + ']'
  end

  def name_birth_tin
    name_birth + ' (' + tin + ')'
  end

  # Returns name with characters (and blanks) only
  # Required for brazilian bank file generation
  def bankingname
    I18n.transliterate(alphabetical_name)
  end

  def alphabetical_name
    name.gsub(/[^a-zA-Z\s]/, ' ')
  end

  # Tests finish

  # Training
  # validate :student_role?

  # 	scope :users, lambda { joins(:user).uniq.order(:name) }

  scope :with_users, -> { joins(:user).uniq.order(:name) }

  scope :with_role, -> { joins(:role).uniq.order(:name) }

  # Without name - Added for 2017 registration season
  scope :nameless, -> { called('') }

  # Training

  # validate :mothers_name_is_present, if: :student_role?
  # validate :ssn_is_consistent, if: :student_role?

  validate :number_of_capitals_is_within_limit

  validate :user_with_staff_permission_must_not_take_on_student_role

  validate :user_with_regular_permission_must_not_take_on_staff_role

  # New for 2018

  def self.latest_contacts_with_student_roles
    with_student_role.where('contacts.created_at > ? ', Schoolterm.latest.start.beginning_of_year)
  end

  def self.latest_student_contact_ids
    latest_contacts_with_student_roles.joins(:student).pluck(:contact_id)
  end

  # Latest
  def self.ready_to_become_students
    latest_contacts_with_student_roles.where.not(id: latest_student_contact_ids)
  end

  # Added for convenience (audit rake tasks) - August 2017
  def self.called(fullname)
    where(name: fullname)
  end

  def user_with_staff_permission_must_not_take_on_student_role
    return unless user.permission.staff? && role.student?
    errors.add(:role_id, :staff_may_not_take_student_role)
  end

  def  user_with_regular_permission_must_not_take_on_staff_role
    return unless user.permission.regular? && role.staff?
    errors.add(:role_id, :student_may_not_take_staff_role)
  end

  def number_of_capitals_is_within_limit
    errors.add(:name, :capitalization) if number_of_caps > 7
  end

  # Calculate number of capital letters
  def number_of_caps
    bankingname.gsub(/[a-z]/, '').delete(' ').length
  end

  # Gender or sex diversity
  def mothers_name_is_present
    return unless personalinfo.mothers_name_is_present
    errors.add(:personalinfo, :mothersname_must_be_present)
  end

  # Brazilian Social Security Number - Verification digit
  def nit_dv
    personalinfo.nit_dv
  end

  def ssn_is_consistent
    return unless personalinfo.nit_is_consistent
    errors.add(personalinfo, :nit_must_be_consistent)
  end

  # New for 2017 - Ability
  def self.veterans_today
    veterans_today_ids = Student.veterans_today.pluck(:contact_id)

    where(id: veterans_today_ids)
  end

  def self.todays_repeats
    repeat_ids_today = Student.todays_repeats.pluck(:contact_id)

    where(id: repeat_ids_today)
  end

  # Alias, for convenience
  # Used in ability.rb
  def self.repeat_registration
    todays_repeats
  end

  def self.makeup
    makeup_ids = Student.makeup.pluck(:contact_id)

    where(id: makeup_ids)
  end

  # Alias, for convenience
  # Used in ability.rb
  def self.makeup_registration
    makeup
  end

  # Has student data
  def self.registered_student
    joins(:student)
  end

  # Has supervisor information
  def self.registered_supervisor
    joins(:supervisor)
  end

  def self.registerable_at_users_institution(u)
    from_own_institution(u).not_registered
  end

  def self.named
    where.not(id: nameless)
  end

  def self.not_student
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: registered_student)
  end

  def self.not_supervisor
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: registered_supervisor)
  end

  # Without registered supervisors or students
  def self.childless
    not_student.not_supervisor
  end

  # --- training

  # Order contacts by institution name
  def self.ordered_by_institution_name
    joins(user: :institution).order('institutions.name')
  end

  # Ordered by most accessed
  def self.ordered_by_most_frequent_users
    joins(:user).order('users.sign_in_count desc')
  end

  # Confirmed
  def self.confirmed
    where(confirmed: true)
  end

  # Not confirmed
  def self.not_confirmed
    where(confirmed: false)
  end

  # Alias
  def self.teacher
    with_teaching_role
  end

  # Alias
  def self.student
    with_student_role
  end

  # here -->
  def name_whitespacing_is_consistent
    return unless (name =~ /['  ']/).nil?
    errors.add(:name, :must_have_consistent_whitespacing)
  end

  def self.with_collaborator_role
    # 			 joins(:role).where(collaborator: true)   # wasn't working on PG.
    joins(:role).where(roles: { collaborator: true }) # Ok, after setting table name explictly
  end

  # retrieve just the contact record belonging to the current user
  # Used in: Assessments

  def self.own(user)
    joins(:user).where(user_id: user.id)
  end

  def self.with_evaluator_role
    with_collaborator_role
  end

  def self.from_institution(i)
    joins(:user).where(users: { institution_id: i.id })
  end

  def self.from_own_institution(user)
    # old syntax
    # 			 joins(:user).where("users.institution_id= ?",user.institution.id)

    joins(:user).where(users: { institution_id: user.institution.id })
  end

  # http://stackoverflow.com/questions/7895595/rails-3-activerecord-association

  def self.pap
    joins(:user).merge(User.pap)
  end

  def self.medres
    joins(:user).merge(User.medres)
  end

  def self.paplocalhr
    joins(:user).merge(User.paplocalhr)
  end

  def self.with_management_role
    joins(:role).merge(Role.management)
  end

  def self.with_student_role
    #  joins(:role).where("roles.teaching=true")
    joins(:role).merge(Role.student)
  end

  def self.with_teaching_role
    #  joins(:role).where("roles.teaching=true")
    joins(:role).merge(Role.teaching)
  end

  def address_country
    address.country
  end

  def address_country_name
    address.country.brname
  end

  def institution
    user.institution
  end

  def self.institution_id
    user.institution_id
  end

  def self.with_assessments
    Assessment.joins(:contact).select(:contact_id).distinct
  end

  # ----------------------

  def nameless?
    name == ''
  end

  def name_and_institution
    name + ' (' + user.institution.name + ')'
  end

  def institution_name
    user.institution.name
  end

  def role_name
    role.name
  end

  def email
    user.email
  end

  def fulladdress
    address.street
    #        [self.streetname.designation, address, addresscomplement].join(" ")
  end

  # 	def self.roletype
  # 			 joins(:roles).where("role_id=roles.id").uniq.order(:name)
  #  	end

  def self.default_scope
    order(name: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  def self.are_registered_supervisors
    joins(:supervisor)
  end

  def self.are_not_registered_supervisors
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: are_registered_supervisors)
  end

  def self.became_students
    joins(:student)
  end

  def self.have_not_become_students
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: became_students)
  end

  def self.possible_students_exist?
    have_not_become_students.with_student_role.count.positive?
  end

  # Contact with student role?
  def student_role?
    role.student?
  end

  def self.not_incoming
    joins(:student).merge(Student.not_incoming)
  end

  def self.incoming
    joins(:student).merge(Student.incoming)
  end

  # Is there a student record for this contact?
  def student?
    student.present?
  end

  # Contacts with student roles but no student records created for them (yet)
  def self.may_become_students
    have_not_become_students.with_student_role
  end

  # Biological sex and gender = M
  def male?
    personalinfo.male?
  end

  # Biological sex and gender = F
  def female?
    personalinfo.female?
  end

  # Gender or sex diversity
  def diversity?
    personalinfo.genderdiversity?
  end

  def user_permission
    user.permission
  end

  def id_i18n
    I18n.t('activerecord.attributes.contact.id') + ': ' + id.to_s
  end

  def details
    name + ' (' + id_i18n + ') | ' + role.name + ' | ' + user.institution.name
  end

  protected

  def with_name_email_postalcode?
    name.present? && email.present? && address.postalcode.present?
  end

  def squish_whitespaces
    return unless with_name_email_postalcode?
    [name, email, address.postalcode].each(&:squish)
  end
end
