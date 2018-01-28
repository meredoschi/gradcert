class Institutiontype < ActiveRecord::Base
  has_many :institution, foreign_key: 'institutiontype_id'
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }

  def self.default_scope
    order(name: :asc) # this notation prevents ambiguity
  end
end
