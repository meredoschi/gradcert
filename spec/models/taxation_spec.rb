# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Taxation, type: :model do
  it 'can be created' do
    print I18n.t('activerecord.models.taxation').capitalize + ': '

    taxation = FactoryBot.create(:taxation, :personal)

    puts taxation.name

    print I18n.t('activerecord.models.bracket').capitalize.pluralize + ': '

    puts taxation.brackets.count.to_s
  end

  it 'computes taxes - PAP scholarship' do
    scholarship = FactoryBot.create(:scholarship, :pap)

    raw_amount = 3 * Scholarship.first.amount # To do: implement contextual

    taxation = FactoryBot.create(:taxation, :personal)

    print 'Raw amount: '
    puts raw_amount
  end
end
