# Useful for health related areas
class Professionalspecialty < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :professionalarea

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  validates :name, presence: true, length: { maximum: 200 }

  validates_uniqueness_of :name, scope: [:professionalarea_id]

  def self.default_scope
    # this notation prevents ambiguity
    # order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous

    joins(:professionalarea).order('professionalspecialties.name', 'professionalareas.name')
  end

  def self.for_area(area)
    where(professionalarea_id: area.id)
  end

  def legacy?
    legacy
  end

  def fullname
    name + ' (' + professionalarea_name + ')'
  end

  def professionalarea_name
    professionalarea.name
  end
end
