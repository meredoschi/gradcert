# Contact with supervisor role
class Supervisor < ActiveRecord::Base
  has_many :diploma, dependent: :destroy
  accepts_nested_attributes_for :diploma, allow_destroy: true

  has_many :courses, dependent: :destroy

  CONTRACTS = %w[Autônomo CLT Estatutário Pessoa\ Jurídica].freeze
  validates :contract_type, inclusion: { in: CONTRACTS }

  validates_uniqueness_of :contact_id

  has_many :assignments, dependent: :restrict_with_exception
  has_many :programs, through: :assignments

  belongs_to :contact
  belongs_to :profession

  validates :contact_id, presence: true
  # Training
  validates :profession_id, presence: true
  #
  %i[career_start_date contract_type].each do |career|
    validates career, presence: true
  end

  def self.medres
    joins(contact: :user).merge(User.medres)
  end

  def self.pap
    joins(contact: :user).merge(User.pap)
  end

  def contact_name
    contact.name
  end

  def profession_name
    profession.name
  end

  def institution_contact_name
    contact.name + ' (' + contact.user.institution.name + ')'
  end

  def self.from_own_institution(user)
    joins(:contact).merge(Contact.from_own_institution(user))
  end

  def self.registered?(user)
    if Supervisor.joins(:contact).where('contacts.user_id= ?', user.id).count == 1

      true

    else false

    end
  end

  def self.user_id(user)
    if registered?(user)

      Supervisor.joins(:contact).where('contacts.user_id= ?', user.id).pluck(:user_id)

    else -1

    end
  end

  def institution_name
    contact.user.institution.name
  end
end
