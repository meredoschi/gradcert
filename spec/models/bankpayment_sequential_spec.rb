# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bankpayment, type: :model do
  it '#in_sequence?' do
    bankpayments = create_list(:bankpayment, 12)

    bankpayment_sequentials = []

    bankpayments.each do |bankpayment|
      bankpayment_sequentials << bankpayment.sequential
    end

    bankpayment_sequentials_array = 1.step(bankpayment_sequentials.size).to_a

    puts bankpayment_sequentials_array.to_s
    expect(bankpayment_sequentials_array).to eq(Bankpayment.sequentials)
  end
end
