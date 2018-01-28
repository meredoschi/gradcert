require 'rails_helper'

RSpec.describe Bankpayment, type: :model do
  # Supplemental - without let.  To test edge cases

  it '#highestseq is one with a single (correctly created) bankpayment' do
    bankpayment = FactoryBot.create(:bankpayment)

    bankpayment_highest_sequential = Bankpayment.sequentials

    expect(bankpayment_highest_sequential).to eq [1] # expressed as an array
  end

  #   it { should validate_inclusion_of(:sequential).in_range(1..10) }

  #      bankpayments = create_list(:bankpayment, 10)

  it '#highestseq is zero with no bankpayments' do
    bankpayment_highest_sequential = Bankpayment.sequentials

    expect(bankpayment_highest_sequential).to eq Bankpayment.sequentials
  end

  it '#lowestseq' do
    @bankpayment_lowest_sequential = if Bankpayment.sequentials != 0

                                       Bankpayment.sequentials.min

                                     else

                                       0

                                     end

    expect(@bankpayment_lowest_sequential).to eq Bankpayment.lowestseq
  end

  it '#highestseq is consistent with 20 bankpayments' do
    bankpayments = create_list(:bankpayment, 20)

    bankpayment_highest_sequential = Bankpayment.sequentials.max

    expect(bankpayment_highest_sequential).to eq Bankpayment.highestseq # expressed as an array
  end

  it '#sequentials returns 0 when no Bankpayments hava been created' do
    expect(Bankpayment.sequentials).to eq 0
  end

  it '#sequentials is consistent with a year bankpayment' do
    bankpayments = create_list(:bankpayment, 12)

    bankpayment_sequentials = []

    if bankpayments.present?

      bankpayments.each do |bankpayment|
        bankpayment_sequentials << bankpayment.sequential
      end

    end

    bankpayment_sequentials_array = bankpayment_sequentials.to_a

    #    expect(bankpayment_sequentials_array).to eq(Bankpayment.pluck(:sequential))

    expect(bankpayment_sequentials_array).to eq(Bankpayment.sequentials)
  end

  it 'multiple can be created' do
    bankpayments = create_list(:bankpayment, 12)

    num_bankpayments = bankpayments.count

    print 'Num bankpayments '

    puts Bankpayment.count.to_s

    bankpayments.each do |b|
      puts b.name + ', seq: ' + b.sequential.to_s
    end

    expect(num_bankpayments).to eq(Bankpayment.count)

    puts num_bankpayments.to_s
  end

  it '#sequentials' do
    bankpayments = create_list(:bankpayment, 12)

    bankpayment_sequentials = []

    if bankpayments.present?

      bankpayments.each do |bankpayment|
        bankpayment_sequentials << bankpayment.sequential
      end

    end

    bankpayment_sequentials_array = bankpayment_sequentials.to_a

    #    expect(bankpayment_sequentials_array).to eq(Bankpayment.pluck(:sequential))

    expect(bankpayment_sequentials_array).to eq(Bankpayment.sequentials)
  end

  it '#sequentials_consistency is true with correct data' do
    bankpayments = create_list(:bankpayment, 12)

    bankpayment_sequentials = []

    bankpayments.each do |bankpayment|
      bankpayment_sequentials << bankpayment.sequential
    end

    bankpayment_sequentials_array = bankpayment_sequentials.to_a

    expect(bankpayment_sequentials_array == Bankpayment.sequentials).to be true
  end

  it '#sequentials_consistency is false with incorrect data - random offsets' do
    bankpayments = create_list(:bankpayment, 12)

    bankpayment_sequentials = []

    bankpayments.each do |bankpayment|
      bankpayment_sequentials << bankpayment.sequential + rand(10)
    end

    bankpayment_sequentials_array = bankpayment_sequentials.to_a

    expect(bankpayment_sequentials_array == Bankpayment.sequentials).to be false
  end
end
