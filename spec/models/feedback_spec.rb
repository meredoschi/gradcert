# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  #  let!(:feedback) { FactoryBot.build(:feedback) }

  #  it { should validate_presence_of(:registration_id) }

  it 'can be created' do
    #  puts feedback.name

    #     print I18n.t('activerecord.models.payroll').capitalize+': '
    #     payroll = FactoryBot.create(:payroll)
    #     puts payroll.name
    #
    #     print I18n.t('activerecord.models.bankpayment').capitalize+': '
    #     bankpayment = FactoryBot.create(:bankpayment)
    #     puts bankpayment.name
    #

    #    print I18n.t('activerecord.models.registration').capitalize+': '
    #    registration = FactoryBot.create(:registration)
    #    puts registration.id.to_s

    print I18n.t('activerecord.models.feedback').capitalize + ': '
    feedback = FactoryBot.create(:feedback)
    puts feedback.name
  end
end
