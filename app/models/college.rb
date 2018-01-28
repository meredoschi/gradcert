class College < ActiveRecord::Base
  belongs_to :institution

  validates :institution_id, presence: true

  %i[area classrooms otherrooms libraries sportscourts foodplaces gradcertificatecourses previousyeargradcertcompletions].each do |n|
    validates n, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  end

  def institution_name
    institution.name
   end
end
