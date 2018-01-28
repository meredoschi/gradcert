class Healthcareinfo < ActiveRecord::Base
  belongs_to :institution

  validates_uniqueness_of :institution_id

  validates :institution_id, presence: true

  %i[totalbeds icubeds ambulatoryrooms labs emergencyroombeds consultations admissions surgeries labexams radiologyprocedures].each do |n|
    validates n, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  end

  validates :equipmenthighlights, presence: true, length: { maximum: 800 }

  validate :number_of_beds_is_consistent

  def number_of_beds_is_consistent
    if totalbeds < (icubeds + emergencyroombeds)

      errors.add(:totalbeds, :inconsistent)

    end
  end

  def institution_name
    institution.name
  end

  def regularbeds
    totalbeds - icubeds - emergencyroombeds
  end
end
