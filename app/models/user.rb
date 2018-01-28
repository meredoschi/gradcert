# Provides user functionality
class User < ActiveRecord::Base
  # @!attribute email
  #   @return [String] Email address for this user.  Must be unique (comes from Devise)

  # @!attribute institution_id
  #   @return [Integer] Participating institution

  # @!attribute permission_id
  #   @return [Integer] This person's permission type

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Marcelo - removed registerable - initial users were seeded

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  has_paper_trail

  #   validates :permission_id, presence: true
  validates :institution_id, presence: true

  # http://stackoverflow.com/questions/808547/fully-custom-validation-error-message-with-rails
  validates :permission_id, presence: true

  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }

  belongs_to :institution

  belongs_to :permission

  has_one :contact, foreign_key: 'user_id'

  # Permission kind
  def kind
    permission.kind
  end

  def self.called(fullname)
    joins(:contact).merge(Contact.called(fullname))
  end
  # User is related to the professional improvement program
  # https://github.com/bbatsov/ruby-style-guide/issues/301
  # rubocop:disable AsciiComments

  def self.pap
    joins(:permission).merge(Permission.pap)
  end

  def self.paplocalhr
    joins(:permission).merge(Permission.paplocalhr)
  end

  # Contacts with a name
  def self.named_contact
    joins(:contact).merge(Contact.named)
  end

  # All users, except system administrators are returned by this method
  def self.visible_to_readonly
    joins(:permission).where("permissions.kind<>'admin'")
  end

  # User is related to the medical residency program ("Programa de Residência Médica")
  def self.medres
    joins(:permission).merge(Permission.medres)

    # 		 where("users.medres=true OR users.medreslocaladm=true OR users.medrescollaborator=true")
  end

  # Users which belong to the same institution
  def self.from_own_institution(user)
    where(users: { institution_id: user.institution.id })
  end

  # User permissions
  def self.permissions
    User.joins(:permission)
  end

  # Convenience method - Demeter's Law
  def contact_name
    contact.name
  end

  # Convenience method
  def permission_type
    permission.kind
  end

  # All users will have an associated contact, and some will be students.
  # E.g. PAP student, medical resident
  def self.with_student_role
    joins(contact: :role).where(roles: { student: true })
  end

  # Conversely, return all users (in reality, contacts) without a student role
  def self.without_student_role
    where.not(id: with_student_role)
  end

  # Return users with management roles within the institutions
  def self.with_management_role
    joins(contact: :role).where(roles: { management: true })
  end

  # Return users without management roles
  def self.without_management_role
    where.not(id: with_management_role) # negates the method above
  end

  # Return users which are neither students nor managers
  # e.g. clerical assistants, Instructors
  def self.neither_student_nor_management
    without_student_role.without_management_role
  end

  # Added for institutions, show view, contacts partial
  def management_role?
    contact.role.management
  end

  # System administrator profile
  def admin?
    permission.admin?
  end

  # For convenience and clarity
  # Managers have wide ranging permissions within their area
  def manager?
    user.permission.manager?
  end

  # clerical staff at the local institution which are responsible for their students
  def localadmin?
    permission.localadmin?
  end

  # Is this person related to the PAP?
  def pap?
    permission.pap?
  end

  # Is this person related to the medical residency program?
  def medres?
    permission.medres?
  end

  # Convenience method.  Order a list of persons (users) by (contact) name
  def self.ordered_by_contact_name
    includes(:contact).order('contacts.name') # http://stackoverflow.com/questions/12164088/ruby-on-rails-order-by-child-attribute
  end

  # Default is to sort by email address.
  def self.default_scope
    order(email: :asc) # this notation prevents ambiguity, good when working with Postgres
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # Finder method
  def self.ordered_by_email
    order(email: :asc)
  end

  # New for 2017

  def id_i18n
    I18n.t('activerecord.attributes.user.id') + ': ' + id.to_s
  end

  def details
    email + ' (' + id_i18n + ') | ' + permission.description + ' | ' + institution.name
  end
end
