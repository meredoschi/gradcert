class Characteristic < ActiveRecord::Base
  validates :institution_id, presence: true

  has_one :funding
  accepts_nested_attributes_for :funding

  belongs_to :institution

  belongs_to :stateregion

  validates :institution_id, presence: true

  %i[mission corevalues userprofile relationwithpublichealthcare highlightareas].each do |txt|
    validates txt, presence: true, length: { maximum: 800 }
  end

  def institution_name
    institution.name
  end

  def self.from_own_institution(user)
    joins(:institution).where(institution_id: user.id)
  end

  def self.regional_office_name
    institution.address.municipality.regionaloffice.name
   end

  # ordinal number, not phone number!
  def self.regional_office_number
    institution.address.municipality.regionaloffice.num
   end
end
