class Taxation < ActiveRecord::Base
  validates :socialsecurity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, presence: true
  has_many  :brackets, dependent: :destroy
  has_many  :payroll

  accepts_nested_attributes_for :brackets, allow_destroy: true

  validates :name, presence: true, length: { maximum: 150 }

  validates :start, presence: true

  def details
    name + ' - ' + I18n.l(start)
  end

  def self.default_scope
    order(start: :desc)
  end

  def social_security_due
    socialsecurity
  end
end
