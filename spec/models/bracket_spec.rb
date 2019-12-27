# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bracket, type: :model do
  # Bracket(num: integer, start_cents: integer, finish_cents: integer, unlimited: boolean,
  # taxation_id: integer, created_at: datetime, updated_at: datetime, rate: decimal, deductible_cents: integer)
  it '-details' do
    bracket = FactoryBot.create(:bracket, :initial)

    curr = bracket.start.currency.symbol.to_s # i.e. R$, US$, etc.

    bracket_details = I18n.t('activerecord.models.bracket').capitalize + \
                      ' ' + bracket.num.to_s + ' - '
    bracket_details += curr + ' ' + bracket.start.to_s + ' ' + I18n.t('to') + ' ' + curr + ' ' + bracket.finish.to_s

    bracket_details += ' - ' + I18n.t('activerecord.attributes.bracket.rate') + ': ' + bracket.rate.to_s + '%'
    expect(bracket_details).to eq(bracket.details)
  end

  it 'can be created' do
    print I18n.t('activerecord.models.bracket').capitalize + ' # '
    bracket = FactoryBot.create(:bracket, :initial)
    puts bracket.num.to_s
    puts bracket.details
  end
end
