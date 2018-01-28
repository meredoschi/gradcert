# From CBO (Brazilian Labor Ministry Official Classification)
class Profession < ActiveRecord::Base
  belongs_to :professionalfamily

  has_many  :assessment, foreign_key: 'profession_id'

  has_many  :diploma, foreign_key: 'diploma_id'

  has_many  :student, foreign_key: 'profession_id'

  # RSPEC start
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 150 }

  validates :occupationcode, presence: true, uniqueness: true

  validates :occupationcode, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 1,
                                             less_than_or_equal_to: 1_000_000 }

  # Instance methods

  def prefix
    occupationcode / 10_000
  end

  def pap
    professionalfamily.pap
  end

  def medres
    professionalfamily.medres
  end

  # Tested code finish

  # http://stackoverflow.com/questions/30129487/activerecord-where-clause-using-function
  scope :with_prefix, ->(p) {
    where('professions.occupationcode / 10000 = ?', p)
  }

  # Starting digit - CBO
  scope :with_digit, ->(p) {
    where('professions.occupationcode / 100000 = ?', p)
  }

  def self.default_scope
    order(name: :asc)
  end

  def self.except_health
    where.not(id: health)
  end

  def self.except_education
    where.not(id: education)
  end

  def self.except_law
    where.not(id: law)
  end

  def self.not_paplocal
    except_law.except_education.except_health
  end

  def self.paplocal
    with_digit(2)

    # 		where.not(:id => self.not_paplocal)
  end

  def self.health
    with_prefix(22)
  end

  def self.education
    with_prefix(23)
  end

  def self.law
    with_prefix(24)
  end

  def self.pap
    #    			 where(:pap=>true)
    joins(:professionalfamily).merge(Professionalfamily.pap)
  end

  def self.medres
    joins(:professionalfamily).merge(Professionalfamily.medres)

    # 			 where(:medres=>true)
  end
end
