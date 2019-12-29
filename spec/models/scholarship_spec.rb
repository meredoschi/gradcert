# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scholarship, type: :model do
  # http://www.rubydoc.info/gems/money-rails/0.8.1
  include MoneyRails::TestHelpers

  let(:taxation) { FactoryBot.create(:taxation, :personal) }
  let(:payroll) { FactoryBot.create(:payroll, :personal_taxation, :special) }
  let(:specified_dt) { Time.zone.today - 60 }

  # Historically set to pap (possible future to do: add gradcert boolean and associated logic)
  let(:scholarship) { FactoryBot.create(:scholarship, :pap) }

  # For additional test coverage
  let(:medres_scholarship) { FactoryBot.create(:scholarship, :medres) } # medical residency

  context 'associations' do
    it { is_expected.to have_many(:payroll).dependent(:restrict_with_exception) }
  end

  context 'creation' do
    it 'can be created multiple times' do
      # http://stackoverflow.com/questions/310634/what-is-the-right-way-to-iterate-through-an-array-in-ruby

      # created_scholarships = create_list(:scholarship, 10)

      start_date = '2010-3-1'
      finish_date = '2011-2-28'
      base_amount = 1000

      (0..10).each do |i|
        schoolyear_start = (start_date.to_date + i.year).to_s

        estimated_finish = finish_date.to_date + i.year

        estimated_finish += 1.day if Date.leap?(estimated_finish.year)

        schoolyear_finish = estimated_finish.to_s

        #  scholarship = FactoryBot.create(:scholarship, start: schoolyear_start,
        FactoryBot.create(:scholarship, start: schoolyear_start,
                                        finish: schoolyear_finish,
                                        amount: base_amount * 1.05**i)

        #  print_scholarship_details(scholarship)
      end
    end
  end

  context 'validations' do
    pending 'prevent start overlap (scoped to kind) with existing records (effectivedates)'
    pending 'prevent finish overlap (scoped to kind) with existing records (effectivedates)'

    it { should validate_presence_of(:start) }

    it { should validate_presence_of(:finish) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:amount_cents) }

    it 'amount cents has to be greather than zero' do
      should validate_numericality_of(:amount_cents)
        .is_greater_than(0)
    end

    it 'inconsistent start and finish dates raise an error' do
      today = Time.zone.today
      start_date = today + 1.year
      finish_date = today - 6.months

      expect do
        FactoryBot.create(:scholarship, start: start_date,
                                        finish: finish_date)
      end    .to raise_error
    end
  end

  context 'class methods' do
    # Alias, for convenience
    it '#contextual_today alias to in_effect_on(Time.zone.today)' do
      scholarships_contextual_today = Scholarship.contextual_today
      expect(scholarships_contextual_today).to eq(Scholarship.contextual_today)
    end

    # Alias
    it '#active alias to contextual_today' do
      active_scholarships = Scholarship.contextual_today
      expect(active_scholarships).to eq(Scholarship.active)
    end

    it '#contextual_on(specified_dt)' do
      scholarship_contextual_on_specified_dt = Scholarship.in_effect_on(specified_dt)
      expect(scholarship_contextual_on_specified_dt).to eq(Scholarship.contextual_on(specified_dt))
    end

    # specified_dt generally will be a payroll's start date (monthworked attribute)
    it '#in_effect_on(specified_dt)' do
      scholarships_in_effect = Scholarship.where('start <= ? and finish >= ?',
                                                 specified_dt, specified_dt)
      expect(scholarships_in_effect).to eq(Scholarship.in_effect_on(specified_dt))
    end

    it '#in_effect_for(payroll)' do
      # Generally one, but theoretically there may be more (e.g. medical residency and gradcert)
      scholarships_in_effect_for_payroll = Scholarship.in_effect_on(payroll.monthworked)
      expect(scholarships_in_effect_for_payroll).to eq(Scholarship.in_effect_for(payroll))
      # The kind will generally be filtered by the pertinent ability at the controller level
    end
  end

  context 'instance methods' do
    # I18n textual representation
    it '-detailed' do
      scholarship.amount = 1500
      scholarship.partialamount = 1200

      scholarship_amount = helper.number_to_currency(scholarship.amount)

      #    detailed_info=scholarship.name+' '+scholarship_amount+' '+scholarship.effectivedates+ \
      #    ' '+I18n.t('created_at')+I18n.l(scholarship.created_at)

      detailed_info = scholarship.name + ' - ' + scholarship.sector + ' - ' + \
                      I18n.t('activerecord.attributes.scholarship.amount') + ' ' \
                       + scholarship_amount + ' - '

      if scholarship.partialamount?

        detailed_info += I18n.t('activerecord.attributes.scholarship.partialamount') + ' ' + \
                         helper.number_to_currency(scholarship.partialamount) + ' - '

      end

      detailed_info += scholarship.effectivedates

      expect(detailed_info).to eq(scholarship.detailed)
    end

    it '-details' do
      scholarship_details = scholarship.amount.symbol + ' ' + scholarship.amount.to_s \
      + ' (' + scholarship.name + ')'
      expect(scholarship_details).to eq(scholarship.details)
    end

    it '-effectiveperiod' do
      effective_period = (scholarship.start)..(scholarship.finish) # defined as a range

      expect(effective_period).to eq(scholarship.effectiveperiod)
    end

    it '-effectivedates' do
      effective_dates = I18n.t('activerecord.attributes.scholarship.virtual.effectiveperiod')
                            .capitalize + ':'

      effective_dates += I18n.l(scholarship.start, format: :dmy) + ' -> ' # textual representation

      effective_dates += I18n.l(scholarship.finish, format: :dmy) # textual representation

      #  puts effective_dates

      expect(effective_dates).to eq(scholarship.effectivedates)
    end

    # I18n textual representation
    it '-kind' do
      scholarship_kind = if scholarship.pap? then I18n.t('activerecord.attributes.scholarship.pap')
                         elsif scholarship.medres? then I18n.t('activerecord.attributes.
                           scholarship.medres')
                         end

      expect(scholarship_kind).to eq(scholarship.kind)
    end

    it '-kind (medres)' do
      scholarship_kind = if medres_scholarship.pap?
                           I18n.t('activerecord.attributes.scholarship.pap')
                         elsif medres_scholarship.medres?
                           I18n.t('activerecord.attributes.scholarship.medres')
                         end

      expect(scholarship_kind).to eq(medres_scholarship.kind)
    end

    # Has partial scholarship amount - for future use
    it '-partialamount?' do
      @has_partial_amount = scholarship.partialamount > 0

      expect(@has_partial_amount).to eq(scholarship.partialamount?)
    end

    # Has partial scholarship amount - for future use
    it 'partialamount? is false when it is zero' do
      scholarship.partialamount = 0

      expect(scholarship.partialamount?).to be false
    end

    # Has partial scholarship amount - for future use
    it 'partialamount? is true if > 0' do
      scholarship.partialamount = 120

      expect(scholarship.partialamount?).to be true
    end

    # just the boolean attribute's name (whichever is true)
    it '-sector' do
      scholarship_sector = if scholarship.pap? then I18n
        .t('activerecord.attributes.scholarship.pap')
                           elsif scholarship.medres? then I18n
                             .t('activerecord.attributes.scholarship.medres')

                           end

      expect(scholarship_sector).to eq(scholarship.sector)
    end

    it '-sector (medres)' do
      scholarship_sector = if medres_scholarship.pap? then I18n
        .t('activerecord.attributes.scholarship.pap')
                           elsif medres_scholarship.medres? then I18n
                             .t('activerecord.attributes.scholarship.medres')

                           end

      expect(scholarship_sector).to eq(medres_scholarship.sector)
    end

    it '-contextual_today?' do
      today = Time.zone.today
      is_in_effect_today = (scholarship.start <= today) && (scholarship.finish >= today)
      expect(is_in_effect_today).to eq(scholarship.contextual_today?)
    end

    # Alias - for convenience
    it '-active?' do
      is_active = scholarship.contextual_today?
      expect(is_active).to eq(scholarship.active?)
    end
  end

  it 'can be created when start and finish dates are provided' do
    #  scholarship = FactoryBot.create(:scholarship)
    scholarship = FactoryBot.create(:scholarship, :pap)

    #  scholarship_amount = helper.number_to_currency(scholarship.amount)

    #  print I18n.t('activerecord.attributes.scholarship.name').capitalize + ': '
    #  puts scholarship.name
    #    puts scholarship_amount
    #    puts scholarship.writtenform

    expect { scholarship }.to_not raise_error
  end

  # Date consistency
  it '-consistent_start_finish? is false with inconsistent dates' do
    today = Time.zone.today
    start_date = today + 1.year
    finish_date = today - 6.months

    scholarship = FactoryBot.build(:scholarship, name: 'PAP - Test',
                                                 pap: true, medres: false,
                                                 start: start_date, finish: finish_date)
    # create here throws an active record invalid error

    # to replace the one created by let

    @consistency = scholarship.start < scholarship.finish

    # .consistent_start_finish?
    expect(scholarship.consistent_start_finish?).to be_falsey
  end

  # Date consistency
  it '-consistent_start_finish? is true with consistent dates' do
    today = Time.zone.today
    start_date = today + 1.year
    finish_date = start_date + 5.months

    scholarship = FactoryBot.create(:scholarship, start: start_date,
                                                  finish: finish_date, amount: 500)

    @consistency = scholarship.start < scholarship.finish

    expect(scholarship.consistent_start_finish?).to be_truthy
  end
end
