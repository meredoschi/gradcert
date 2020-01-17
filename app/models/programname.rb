# frozen_string_literal: true

# Program names
class Programname < ActiveRecord::Base
  has_paper_trail

  ABBREVIATION_LENGTH = Settings.shortname_len.program # originally defined in the programs model

  has_many :program, foreign_key: 'programname_id',
                     dependent: :restrict_with_exception, inverse_of: :programname
  # validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }

  #   belongs_to :programname_id, class_name: "Programname"

  validates :name, presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 200 }

  %i[previousname comment].each do |info|
    validates info, length: { maximum: 200 }
  end

  #   has_many  :assesment, :through => :program ? assessment index search

  # http://stackoverflow.com/questions/18082096/rails-4-scope-to-find-parents-with-no-children
  scope :with_children, -> { joins(:program).uniq.order(:name) }

  # http://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html
  scope :pap, -> { where(pap: true).order(:name) }

  scope :medres, -> { where(medres: true).order(:name) }

  scope :active, -> { where(active: true).order(:name) }

  scope :retired, -> { where(active: false) }

  scope :legacy, -> { where(legacy: true) }

  def self.default_scope
    order(name: :asc)
  end

  # Extinct
  def inactive?
    !active
  end

  # Extinct
  def legacy?
    legacy
  end

  def self.inactive
    retired
  end

  def name_with_id
    '[ ID ' + id.to_s + ' ] ' + name
  end

  # Shortened, abbreviated name (in case it was very long)
  def short
    if name.length > ABBREVIATION_LENGTH

      name[0..len] + '...'

    else

      name

    end
  end

  # Alias
  def short_name
    short
  end

  # http://api.rubyonrails.org/classes/ActiveRecord/Querying.html
  #  def self.with_assessment
  #    find_by_sql 'select * from programnames pn, programs p, assessments a '\
  #    'where p.programname_id=pn.id and a.program_id=p.id'

  # self.find_by_sql ["SELECT title FROM posts WHERE author = ? AND created > ?", author_id, start_date]
  #  end
end
