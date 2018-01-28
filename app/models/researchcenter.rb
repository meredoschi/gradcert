class Researchcenter < ActiveRecord::Base
  belongs_to :institution

  validates :institution_id, presence: true

  %i[rooms labs intlprojectsdone ongoingintlprojects domesticprojectsdone ongoingdomesticprojects].each do |n|
    validates n, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  end

  def institution_name
    institution.name
   end

  def domestic
    ongoingdomesticprojects + domesticprojectsdone
  end

  def international
    ongoingintlprojects + intlprojectsdone
  end

  def ongoing
    ongoingintlprojects + ongoingdomesticprojects
  end

  def completed
    intlprojectsdone + domesticprojectsdone
  end

  def production
    completed + ongoing
  end
end
