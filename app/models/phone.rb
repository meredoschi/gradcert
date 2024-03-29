# frozen_string_literal: true

# Telephone numbers
class Phone < ActiveRecord::Base
  # ------------------- References ------------------------

  has_paper_trail

  belongs_to :contact # individual (person)

  # Organizations
  belongs_to :bankbranch, optional: true
  belongs_to :council, optional: true
  belongs_to :institution, optional: true
  belongs_to :regionaloffice, optional: true

  validates :main, presence: true, length: { minimum: 6, maximum: 30 }, unless: :individual?

  validates :mobile, presence: true, length: { minimum: 8, maximum: 25 }, if: :individual?

  def individual?
    contact_id.present?
  end

  def bankbranch?
    bankbranch.present?
  end

  def council?
    council.present?
  end

  def institution?
    institution.present?
  end

  def regionaloffice?
    regionaloffice.present?
  end
end
