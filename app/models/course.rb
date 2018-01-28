class Course < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :coursename

  belongs_to :professionalfamily
  belongs_to :supervisor
  belongs_to :program

  belongs_to :methodology

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  has_one :address
  accepts_nested_attributes_for :address

  validates_uniqueness_of :program_id, scope: %i[coursename_id supervisor_id]

  validates_numericality_of :workload, greater_than_or_equal_to: 0, less_than_or_equal_to: 3000

  validates_inclusion_of [:core], in: [false], if: :is_professionalrequirement?

  validates_inclusion_of [:professionalrequirement], in: [false], if: :is_core?

  %i[program_id methodology_id coursename_id profession_id supervisor_id].each do |ids|
    validates ids, presence: true
  end

  def required?
    if is_core? || is_professionalrequirement?

      true

    else

      false

    end
  end

  def is_practical?
    practical == true
  end

  def is_core?
    core == true
  end

  def is_professionalrequirement?
    professionalrequirement == true
  end

  def institution_name
    program.institution.name
  end

  def methodology_name
    methodology.name
  end

  def program_name
    program.programname.name
  end

  # def self.course_name

  # 		coursename.name

  # end

  # def self.default_scope
  # this notation prevents ambiguity
  #     order(course_name: :asc)
  # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  # end

  # ***********************************************************************************************************************************
end
