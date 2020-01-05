class Assignment < ActiveRecord::Base
  belongs_to :program
  belongs_to :supervisor

  validates_uniqueness_of :supervisor_id, scope: [:program_id]

  validate :start_date_not_in_the_future

  %i[program_id supervisor_id start_date].each do |s|
    validates s, presence: true
  end

  def start_date_not_in_the_future
    if start_date > Date.today
      errors.add(:start_date, :may_not_be_in_the_future)
    end
  end

  # http://stackoverflow.com/questions/7004008/rails-3-validate-uniqueness-of-one-value-against-a-column
  validates :main, uniqueness: { scope: :program_id }, if: :main

  def self.has_main_supervisor?(prog)
    if for_program(prog).main.count.positive?

      true

    else

      false

end
  end

  def self.for_program(prog)
    includes(:program).where(program: prog)
  end

  # i.e. main supervisor for the program
  # 	scope :main, where(main: true)

  def self.main
    where(main: true)
    end

  def self.pap
    joins(:program).merge(Program.pap)
  end

  def self.medres
    joins(:program).merge(Program.medres)
  end

  def self.default_scope
    order('start_date DESC')
  end

  def self.contact_name
    supervisor.contact.name
  end

  def self.institution_name
    supervisor.institution_name
  end

  # http://stackoverflow.com/questions/22720472/select-objects-based-on-grandchild-attribute-with-joins-in-activerecord
  def self.exists_for_supervisor?(user)
    if Assignment.includes(supervisor: :contact).where(contacts: { user_id: user }).count.positive?

      true

    else

      false

    end
  end
end
