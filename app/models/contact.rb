# frozen_string_literal: true

# All system users must have a respective contact object by design
class Contact < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'

  #   before_validation :squish_whitespaces

  has_paper_trail

  mount_uploader :image, ImageUploader # Carrierwave, photo uploads

  validates :name, presence: true, length: { maximum: 200 }
  validates :name, uniqueness: { scope: [:address_id] }

  validates :role_id, presence: true

  #   validates :name, format: { with: /[A-Z]+/, message: I18n.t('only_letters_allowed') }

  # https://pt.wikipedia.org/wiki/Cadastro_de_Pessoas_F%C3%ADsicas

  # Primeiro digito verificador do CPF

  # Initial tests written - Marcelo - March 2018
  # Review in progress - Marcelo - January 2020

  # Associations

  belongs_to :role

  belongs_to :student

  belongs_to :user, dependent: :delete

  has_many :assessment, foreign_key: 'contact_id',
                        dependent: :restrict_with_exception, inverse_of: :contact

  has_many  :supervisor, foreign_key: 'contact_id',
                         dependent: :restrict_with_exception, inverse_of: :contact

  has_many  :student, foreign_key: 'contact_id',
                      dependent: :restrict_with_exception, inverse_of: :contact

  has_one :address, foreign_key: 'contact_id',
                    dependent: :restrict_with_exception, inverse_of: :contact

  accepts_nested_attributes_for :address

  has_one :phone, foreign_key: 'contact_id',
                  dependent: :restrict_with_exception, inverse_of: :contact

  accepts_nested_attributes_for :phone

  has_one :webinfo, foreign_key: 'contact_id',
                    dependent: :restrict_with_exception, inverse_of: :contact

  accepts_nested_attributes_for :webinfo

  has_one :personalinfo, foreign_key: 'contact_id',
                         dependent: :restrict_with_exception, inverse_of: :contact

  accepts_nested_attributes_for :personalinfo

  # Scopes

  #   scope :users, lambda { joins(:user).uniq.order(:name) }

  scope :with_users, -> { joins(:user).uniq.order(:name) }

  scope :with_role, -> { joins(:role).uniq.order(:name) }

  scope :confirmed, -> { where(confirmed: true) }

  scope :not_confirmed, -> { where(confirmed: false) }

  # Without name - Added for the 2017 registration season
  scope :nameless, -> { called('') }

  # Training
  # validate :student_role?

  # <<< Validations >>>

  # Training sessions 2017 (institutional users)

  # validate :mothers_name_is_present, if: :student_role?
  # validate :ssn_is_consistent, if: :student_role?

  validate :name_whitespacing_is_consistent

  validate :number_of_capitals_is_within_limit

  validate :user_with_staff_permission_must_not_take_on_student_role

  validate :student_may_not_be_assigned_a_staff_role

  # <<< Class methods >>>

  # New for 2020

  # Taken to mean registered *students*
  def self.registered
    joins(student: :registration)
  end

  # Are not registered students
  def self.not_registered
    where.not(id: registered)
  end

  # Are supervisors
  def self.supervisor
    joins(:supervisor)
  end

  # Not supervisors (i.e. without a supervisor record associated with it, regardless of role)
  def self.not_supervisor
    where.not(id: supervisor)
  end

  # New for 2018

  def self.latest_contacts_with_student_roles
    latest_schoolterm = Schoolterm.latest

    if latest_schoolterm.present? && latest_schoolterm.start.present?

      latest_term_beginning_of_calendar_year = latest_schoolterm.start.beginning_of_year
      recent_contacts_with_student_roles = with_student_role
                                           .where('contacts.created_at > ? ',
                                                  latest_term_beginning_of_calendar_year)

    end

    recent_contacts_with_student_roles
  end

  def self.latest_student_contact_ids
    most_recent_students = latest_contacts_with_student_roles

    return most_recent_students.joins(:student).pluck(:contact_id) if most_recent_students.present?
  end

  # Latest
  def self.ready_to_become_students
    latest_contacts_with_a_student_role = latest_contacts_with_student_roles

    if latest_contacts_with_a_student_role.present?
      contacts_ready_to_become_students = self.latest_contacts_with_a_student_role
                                              .where.not(id: Contact.latest_student_contact_ids)
    end

    contacts_ready_to_become_students
  end

  # Added for convenience (audit rake tasks) - August 2017
  def self.called(fullname)
    where(name: fullname)
  end

  def user_with_staff_permission_must_not_take_on_student_role
    return unless user.permission.staff? && role.student?

    errors.add(:role_id, :staff_may_not_take_student_role)
  end

  def student_may_not_be_assigned_a_staff_role
    return unless user.permission.regular? && role.staff?

    errors.add(:role_id, :student_may_not_take_staff_role)
  end

  def number_of_capitals_is_within_limit
    errors.add(:name, :capitalization) if number_of_caps > 7
  end

  # Gender or sex diversity
  def mothers_name_is_present
    return unless personalinfo.mothers_name_is_present

    errors.add(:personalinfo, :mothersname_must_be_present)
  end

  def ssn_is_consistent
    return unless personalinfo.nit_is_consistent

    errors.add(personalinfo, :nit_must_be_consistent)
  end

  # <<< Class methods >>>

  # New for 2017 - Ability
  def self.veterans_today
    todays_veteran_students_contact_ids = Student.veterans_today.pluck(:contact_id)
    todays_veteran_students = where(id: todays_veteran_students_contact_ids)
    todays_veteran_students
  end

  # current repeating students
  def self.todays_repeats
    todays_repeat_students_contact_ids = Student.veterans_today.pluck(:contact_id)
    todays_repeat_students = where(id: todays_repeat_students_contact_ids)
    todays_repeat_students
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

  # Has a student record associated to it (need not be registered in a program yet)
  # To better distinguish from registered students
  def self.with_student_information
    joins(:student)
  end

  def self.without_student_information
    where.not(id: with_student_information)
  end

  # Has supervisor information
  def self.registered_supervisor
    joins(:supervisor)
  end

  def self.from_own_institution_but_not_registered_yet(user)
    from_own_institution(user).not_registered
  end

  def self.named
    where.not(id: nameless)
  end

  def self.not_supervisor
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: registered_supervisor)
  end

  # Without student or supervisor records associated with it
  def self.plain
    without_student_information.not_supervisor
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

  # Alias
  def self.teacher
    with_teaching_role
  end

  def name_whitespacing_is_consistent
    # may not start with a whitespace
    # two (or more) spaces in sequence are not allowed
    # may not end with a blank space
    return if (name =~ /(\A\s|\s{2,}|\s\z)/).blank?

    errors.add(:name, :must_have_consistent_whitespacing)
  end

  def self.with_collaborator_role
    #        joins(:role).where(collaborator: true)   # wasn't working on PG.
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

  def self.from_institution(institution)
    joins(:user).where(users: { institution_id: institution.id })
  end

  def self.from_own_institution(user)
    # old syntax
    #        joins(:user).where("users.institution_id= ?",user.institution.id)

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

  def self.ids_with_assessments
    Assessment.joins(:contact).select(:contact_id).distinct
  end

  #   def self.roletype
  #        joins(:roles).where("role_id=roles.id").uniq.order(:name)
  #    end

  def self.default_scope
    order(name: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # Contacts with student roles but no student records created for them (yet)
  def self.may_become_students
    with_student_role.without_student_information
  end

  def self.possible_students_exist?
    may_become_students.count.positive?
  end

  def self.num_ready_to_become_students
    num_contacts_ready_to_become_students = 0

    if ready_to_become_students.present?
      num_contacts_ready_to_become_students = Contact.ready_to_become_students.count
    end

    num_contacts_ready_to_become_students
  end

  # <<< Instance methods >>>

  delegate :country, to: :address, prefix: true

  delegate :email, to: :user

  delegate :institution, to: :user

  delegate :name, to: :role, prefix: true

  # Brazilian Social Security Number - Verification digit
  delegate :nit_dv, to: :personalinfo

  # Calculate number of capital letters
  def number_of_caps
    bankingname.gsub(/[a-z]/, '').delete(' ').length
  end

  def nameless?
    name == ''
  end

  def name_and_institution
    name + ' (' + institution_name + ')'
  end

  def institution_name
    user.institution.name
  end

  def fulladdress
    address.street
  end

  # Contact with student role?
  def student_role?
    role.student?
  end

  # Is there a student record for this contact?
  def student?
    student.present?
  end

  # Biological sex and gender = M
  delegate :male?, to: :personalinfo

  # Biological sex and gender = F
  delegate :female?, to: :personalinfo

  # Gender or sex diversity
  def diversity?
    personalinfo.genderdiversity?
  end

  delegate :permission, to: :user, prefix: true

  def id_i18n
    I18n.t('activerecord.attributes.contact.id') + ': ' + id.to_s
  end

  def details
    name + ' (' + id_i18n + ') | ' + role_name + ' | ' + institution_name
  end

  delegate :tin, to: :personalinfo

  # Alias, for convenience (in Brazil)
  def cpf
    tin
  end

  delegate :birth, to: :personalinfo

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

  protected

  def with_name_email_postalcode?
    name.present? && email.present? && address.postalcode.present?
  end

  def squish_whitespaces
    return unless with_name_email_postalcode?

    [name, email, address.postalcode].each(&:squish)
  end
end
