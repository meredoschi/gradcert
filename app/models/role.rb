# Provides role functionality
class Role < ActiveRecord::Base
  TYPES = %i[management teaching clerical collaborator student itstaff].freeze
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }

  has_many  :contact, foreign_key: 'role_id'

  scope :pap, -> { where(pap: true) }
  scope :medres, -> { where(pap: medres) }

  scope :clericalworker, -> { where(clerical: true) }
  scope :teacher, -> { where(teaching: true) }
  scope :management, -> { where(management: true) }
  scope :student, -> { where(student: true) }

  scope :collaborator, -> { where(collaborator: true) }

  scope :itstaff, -> { where(itstaff: true) }

  # returns all roles with contacts, not just own institution's.
  scope :from_contacts, -> { joins(:contact).uniq.order(:name) }

  validates_inclusion_of %i[teaching management collaborator student itstaff], in: [false], if: :clerical?

  # TDD - Start - August 2017

  before_save :type_consistency

  def type_consistency
    return unless exactly_one_type_selected?
    errors.add(:_, 'Exactly one type must be selected')
  end


  # TDD - end

  # Aliases
  def self.learner
    student
  end

  def self.teaching
    teacher
  end

  def self.default_scope
    order(name: :asc)
  end

  # Alias
  def self.clerical
    clerical
  end

  # 2017 Registration season
  def self.staff
    where.not(id: student)
  end

  def staff?
    !student? # student here is the boolean
  end

  def self.internal
    where.not(id: collaborator)
  end

  def self.seen_by_paplocal
    internal.pap
  end

  def self.paplocal
    #   Forbid this thru a custom validation instead.

    #		if Schoolterm.open_season?

    #        self.student.pap

    #		else

    internal.pap

    #		end
  end

  # http://stackoverflow.com/questions/28951671/argument-error-the-scope-body-needs-to-be-callable
  # Old syntax -->
  #   scope :teacher, where(teaching: true)

  # validate :roletype_is_unique

  # 	validate :admin_appropriately_set

  # 	validate :adminreadonly_appropriately_set

  #	 validate :pap_appropriately_set

  #   	validate :pap_local_admin_appropriately_set

  # 	validate :medical_residency_appropriately_set

  # 	validate :medical_residency_local_admin_appropriately_set

  def clerical?
    clerical == true
  end

  def teaching?
    teaching == true
  end

  def management?
    management == true
  end

  def collaborator?
    collaborator == true
  end

  def student?
    student == true
  end

  def itstaff?
    itstaff == true
  end

  def types_selected
    role_types_selected = []

    TYPES.each do |t|
      #      role_types_selected << t if eval(t.to_s) == true

      role_types_selected << t if send(t)
    end

    role_types_selected
  end

  def num_types_selected
    types_selected.count
  end

  def exactly_one_type_selected?
    if num_types_selected == 1
      true
    else
      false
    end
  end

  def roletype_is_unique
    if clerical? then validates_inclusion_of %i[teaching management
                                                collaborator student itstaff], in: [false]
    elsif teaching? then validates_inclusion_of %i[management clerical
                                                   collaborator student itstaff], in: [false]
    elsif management?
      validates_inclusion_of %i[teaching clerical collaborator student
                                itstaff], in: [false]
    elsif collaborator?
      validates_inclusion_of validates_inclusion_of %i[teaching clerical
                                                       management student itstaff], in: [false]
    elsif student?
      validates_inclusion_of %i[teaching clerical management collaborator
                                itstaff], in: [false]
    elsif itstaff?
      validates_inclusion_of %i[teaching clerical management collaborator
                                student], in: [false]
    else
      errors.add(:name, :all_blank)
      %i[clerical collaborator teaching student management].each do |kind|
        errors.add(kind, :explanation)
      end

    end
  end
end
