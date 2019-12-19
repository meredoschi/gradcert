# frozen_string_literal: true

require 'rails_helper'

describe Extra, type: :helper do
  let(:gross_amount) { 1200 }
  let(:taxation) { FactoryBot.create(:taxation, :personal) }

  it 'calculates social security taxes' do
    social_security_due = Extra.calculate_social_security(gross_amount, taxation)

    expect(Extra.calculate_social_security(gross_amount, taxation)).to eq social_security_due
  end
end
