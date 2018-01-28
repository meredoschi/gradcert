class Phone < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :bankbranch
  belongs_to :contact
  belongs_to :council
  belongs_to :institution
  belongs_to :regionaloffice

  validates :main, presence: true, length: { minimum: 6, maximum: 30 }, on: :update

  has_paper_trail
end
