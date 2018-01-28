require 'rails_helper'

RSpec.describe Scholarship, type: :model do
  # http://www.rubydoc.info/gems/money-rails/0.8.1
  include MoneyRails::TestHelpers

  # single scholarship
  let(:scholarship) { scholarship = FactoryBot.create(:scholarship, :pap) }

  # To do: prevent start-finish overlap (within the same program)

  def create_sample_scholarships
    start_date = '2010-3-1'
    finish_date = '2011-2-28'
    base_amount = 1000

    (0..10).each do |i|
      schoolyear_start = (start_date.to_date + i.year).to_s

      estimated_finish = finish_date.to_date + i.year

      estimated_finish += 1.day if Date.leap?(estimated_finish.year)

      schoolyear_finish = estimated_finish.to_s

      scholarship = FactoryBot.create(:scholarship, start: schoolyear_start, finish: schoolyear_finish, amount: base_amount * 1.05**i)
    end
  end

  def print_scholarship_details(s)
    print s.name
    print ' '
    print s.amount
    print ' '
    print s.effectiveperiod
    print ' '
    print I18n.t('created_at')
    puts I18n.l(scholarship.created_at)
  end

  # I18n textual representation
  it '-kind' do
    scholarship_kind = if scholarship.pap? then I18n.t('activerecord.attributes.scholarship.pap')
                       elsif scholarship.medres? then I18n.t('activerecord.attributes.scholarship.medres')
  end

    expect(scholarship_kind).to eq(scholarship.kind)
  end

  # I18n textual representation
  it '-detailed' do
    scholarship.amount = 1500
    scholarship.partialamount = 1200

    scholarship_amount = helper.number_to_currency(scholarship.amount)

    #    detailed_info=scholarship.name+' '+scholarship_amount+' '+scholarship.effectivedates+' '+I18n.t('created_at')+I18n.l(scholarship.created_at)

    detailed_info = scholarship.name + ' - ' + scholarship.sector + ' - ' + I18n.t('activerecord.attributes.scholarship.amount') + ' ' + scholarship_amount + ' - '

    if scholarship.partialamount?

      detailed_info += I18n.t('activerecord.attributes.scholarship.partialamount') + ' ' + helper.number_to_currency(scholarship.partialamount) + ' - '

    end

    detailed_info += scholarship.effectivedates

    expect(detailed_info).to eq(scholarship.detailed)
  end

  # Has partial scholarship amount - for future use
  it '-partialamount?' do
    @has_partial_amount = if scholarship.partialamount > 0

                            true

                          else

                            false

                        end

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
    scholarship_sector = if scholarship.pap? then I18n.t('activerecord.attributes.scholarship.pap')
                         elsif scholarship.medres? then I18n.t('activerecord.attributes.scholarship.medres')

  end

    expect(scholarship_sector).to eq(scholarship.sector)
  end

  it 'can be created when start and finish dates are provided' do
    #  scholarship = FactoryBot.create(:scholarship)
    scholarship = FactoryBot.create(:scholarship, :pap)

    scholarship_amount = helper.number_to_currency(scholarship.amount)

    print I18n.t('activerecord.attributes.scholarship.name').capitalize + ': '
    puts scholarship.name
    #    puts scholarship_amount
    #    puts scholarship.writtenform

    expect { scholarship }.to_not raise_error
  end

  it { should validate_presence_of(:start)  }

  it { should validate_presence_of(:finish) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:amount_cents) }

  it 'amount cents has to be greather than zero' do
    should validate_numericality_of(:amount_cents)
      .is_greater_than(0)
  end

  it 'inconsistent start and finish dates raise an error' do
    today = Date.today
    start_date = today + 1.year
    finish_date = today - 6.months

    expect { FactoryBot.create(:scholarship, start: start_date, finish: finish_date) }.to raise_error
  end

  it '-effectiveperiod' do
    effective_period = (scholarship.start)..(scholarship.finish) # defined as a range

    expect(effective_period).to eq(scholarship.effectiveperiod)
  end

  it '-effectivedates' do
    effective_dates = I18n.t('activerecord.attributes.scholarship.virtual.effectiveperiod').capitalize + ':'

    effective_dates += I18n.l(scholarship.start, format: :dmy) + ' -> ' # textual representation

    effective_dates += I18n.l(scholarship.finish, format: :dmy) # textual representation

    puts effective_dates

    expect(effective_dates).to eq(scholarship.effectivedates)
  end

  # Date consistency
  it '-consistent_start_finish? is false with inconsistent dates' do
    today = Date.today
    start_date = today + 1.year
    finish_date = today - 6.months

    scholarship = FactoryBot.build(:scholarship, name: 'PAP - Test', pap: true, medres: false, start: start_date, finish: finish_date)
    # create here throws an active record invalid error

    # to replace the one created by let

    @consistency = if scholarship.start < scholarship.finish

                     true

                   else

                     false

                   end

    # .consistent_start_finish?
    expect(scholarship.consistent_start_finish?).to be_falsey
  end

  # Date consistency
  it '-consistent_start_finish? is true with consistent dates' do
    today = Date.today
    start_date = today + 1.year
    finish_date = start_date + 5.months

    scholarship = FactoryBot.create(:scholarship, start: start_date, finish: finish_date, amount: 500)

    @consistency = if scholarship.start < scholarship.finish

                     true

                   else

                     false

                   end

    expect(scholarship.consistent_start_finish?).to be_truthy
  end

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

      scholarship = FactoryBot.create(:scholarship, start: schoolyear_start, finish: schoolyear_finish, amount: base_amount * 1.05**i)

      print_scholarship_details(scholarship)
    end
  end

  # "Contextual today"
  # To do
  it '-active?' do
    #      FactoryBot.build_list(:scholarship, 5)

    #      puts Scholarship.count

    today = Date.today
    todays_range = today..today

    start_date = '2010-3-1'
    finish_date = '2011-2-28'
    base_amount = 1000

    (0..10).each do |i|
      schoolyear_start = (start_date.to_date + i.year).to_s

      estimated_finish = finish_date.to_date + i.year

      estimated_finish += 1.day if Date.leap?(estimated_finish.year)

      schoolyear_finish = estimated_finish.to_s

      scholarship = FactoryBot.create(:scholarship, start: schoolyear_start, finish: schoolyear_finish, amount: base_amount * 1.05**i)

      puts scholarship.detailed

      print '  Active: '
      puts scholarship.effectiveperiod.overlaps? todays_range
    end

    scholarship_ids = Scholarship.pluck(:id)

    #    puts scholarship_ids

    #    print "Sample -> "

    #    random_scholarship_id=scholarship_ids.sample

    #    puts random_scholarship_id

    #    random_scholarship=Scholarship.find random_scholarship_id

    #    puts random_scholarship.detailed
  end

  # "Contextual today"
  it '#active' do
    create_sample_scholarships

    today = Date.today
    todays_range = today..today

    puts 'ids_contextual_today'

    contextual_ids = []

    scholarships = Scholarship.ordered_by_newest

    # Using s not to confuse with :scholarship defined by let
    # And also for shorthand

    scholarships.each do |s|
      puts s.detailed

      next unless s.active?

      contextual_ids << s.id
    end

    print 'IDs in context today -> '
    puts contextual_ids

    active_scholarships = scholarships.where(id: contextual_ids)

    active_scholarships.each do |s|
      puts s.detailed
    end

    expect(active_scholarships).to eq(Scholarship.active)
  end
end
