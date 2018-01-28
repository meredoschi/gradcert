# Systematic catalog of the various kinds of roads (Rua, Rue, Street, Avenida, Avenue) and so forth
class Streetname < ActiveRecord::Base
  has_many :institution, foreign_key: 'streetname_id'

  has_many  :contact, foreign_key: 'streetname_id'
  has_many  :address, foreign_key: 'streetname_id'

  # RSPEC start
  validates :designation, presence: true,
                          uniqueness: { case_sensitive: false }, length:  { maximum: 50 }
  # Tested code finish

  def self.default_scope
    order(designation: :asc)
  end
end
