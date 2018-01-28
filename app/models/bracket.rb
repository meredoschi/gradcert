class Bracket < ActiveRecord::Base
  belongs_to :taxation

  validates :rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, presence: true

  validates :num, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: Settings.max_tax_brackets }, presence: true

  validates :deductible, numericality: { greater_than_or_equal_to: 0, integer: true }, presence: true

  scope :highest, -> { where(unlimited: true) }

  # http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money

  monetize :start_cents
  monetize :finish_cents
  monetize :deductible_cents

  # i.e. not highest
  scope :except_the_highest, -> { where(unlimited: false) }

  scope :initial, -> { where(num: 1) }

  def self.default_scope
    order(num: :asc)
  end

  def self.intermediate
    except_the_highest
  end

  def self.for_taxation(taxation)
    where(taxation_id: taxation.id)
  end

  # TDD
  def details
    curr = start.currency.symbol.to_s # i.e. R$, US$, etc.

    txt = I18n.t('activerecord.models.bracket').capitalize + ' ' + num.to_s + ' - '
    txt += curr + ' ' + start.to_s + ' ' + I18n.t('to') + ' ' + curr + ' ' + finish.to_s

    txt += ' - ' + I18n.t('activerecord.attributes.bracket.rate') + ': ' + rate.to_s + '%'

    txt
  end
end
