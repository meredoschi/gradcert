require 'rails_helper'

RSpec.describe Payroll, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  let(:payroll) { FactoryBot.create(:payroll, :personal_taxation) }

  let(:dt) { Date.today - 60 }

  MAX_COMMENT_LEN = Settings.maximum_comment_length.payroll

  # Currently applies to special payrolls only
  def prefix
    @txt = ''

    if payroll.special?
      @txt = '*' + I18n.t('activerecord.attributes.payroll.special')
      @txt += ' *  [' + comment + '] '

    end

    @txt = ''
  end

  it { is_expected.to validate_length_of(:comment).is_at_most(MAX_COMMENT_LEN) }

  #  let(:admission) { FactoryBot.create(:admission, :zero_amounts) }

  it { is_expected.to validate_presence_of(:paymentdate) }
  it { is_expected.to validate_presence_of(:taxation_id) }
  it { is_expected.to validate_presence_of(:monthworked) }

  it '-dstart' do
    payroll_dstart = payroll.start.to_datetime.to_i / (3600 * 24)

    expect(payroll_dstart).to eq(payroll.dstart)
  end

  # Day finished - as integers

  it '-dfinish' do
    payroll_dfinish = payroll.finish.to_datetime.to_i / (3600 * 24)

    expect(payroll_dfinish).to eq(payroll.dfinish)
  end

  it 'pap? is true for PAP payroll' do
    expect(payroll.pap?).to be true
  end

  it 'pap? is false for MEDRES payroll' do
    payroll = FactoryBot.create(:payroll, :personal_taxation, :medres)

    expect(payroll.pap?).to be false
  end

  it 'pap? is true for PAP payroll' do
    expect(payroll.pap?).to be true
  end

  it 'medres? is false for PAP payroll' do
    payroll = FactoryBot.create(:payroll, :personal_taxation) # default is PAP

    expect(payroll.medres?).to be false
  end

  it 'medres? is true for Medical Residency payroll' do
    payroll = FactoryBot.create(:payroll, :personal_taxation, :medres) # default is PAP

    expect(payroll.medres?).to be true
  end

  it '-sector' do
    payroll_sector = I18n.t('activerecord.attributes.payroll.pap') if payroll.pap?

    payroll_sector = I18n.t('activerecord.attributes.payroll.medres') if payroll.medres?

    expect(payroll_sector).to eq payroll.sector
    #    payroll_sector
  end

  it 'is_annotated?' do
    @payroll_annotation_status = false

    @payroll_annotation_status = true if payroll.annotated

    expect(@payroll_annotation_status).to eq(payroll.is_annotated?)

    #    @status
  end

  it '-annotated? alias to is_annotated?' do
    expect(payroll.annotated?).to eq(payroll.is_annotated?)
  end

  it 'not_annotated? is the reverse of is_annotated?' do
    expect(payroll.not_annotated?).to eq(!payroll.is_annotated?)
  end

  it '#dataentrystart (local admins at institutions)' do
    # payroll = FactoryBot.create(:payroll)

    payroll_dataentrystart = payroll.dataentrystart

    expect(payroll_dataentrystart).to eq(payroll.dataentrystart)
  end

  it '#dataentrystart can be set to right now' do
    # payroll = FactoryBot.create(:payroll)

    right_now = Time.now

    payroll.dataentrystart = right_now

    expect(payroll.dataentrystart).to eq(right_now)
  end

  it '#dataentryfinish (local admins at institutions)' do
    # payroll = FactoryBot.create(:payroll)

    payroll_dataentryfinish = payroll.dataentryfinish

    expect(payroll_dataentryfinish).to eq(payroll.dataentryfinish)
  end

  it '#dataentryfinish can be set to right now' do
    puts '#dataentryfinish can be set to right now'

    right_now = Time.now

    # payroll = FactoryBot.create(:payroll)

    payroll.dataentryfinish = right_now

    expect(payroll.dataentryfinish).to eq(right_now)

    puts right_now.to_s
  end

  it '-dataentryperiod' do
    # payroll = FactoryBot.create(:payroll)

    dataentryperiod = payroll.dataentrystart..payroll.dataentryfinish

    expect(payroll.dataentryperiod).to eq(dataentryperiod)
  end

  it '-prefix' do
    payroll_prefix = payroll.prefix

    expect(payroll.prefix).to eq(payroll_prefix)
  end

  it '-range' do
    puts 'Inside payroll range'
    payroll_range = payroll.range
    expect(payroll.range).to eq(payroll_range)
    puts payroll.range
  end

  it '-dataentrypermitted?' do
    # payroll = FactoryBot.create(:payroll)

    start = payroll.dataentrystart

    finish = payroll.dataentryfinish

    right_now = Time.now

    data_entry_permitted = Logic.within?(start, finish, right_now) # returs a boolean

    expect(payroll.dataentrypermitted?).to eq(data_entry_permitted)
  end

  it 'payment_date_consistent?' do
    payroll_month_worked = payroll.monthworked.beginning_of_month
    month_before_payment = payroll.paymentdate.beginning_of_month.last_month

    # IMPORTANT: Working month is assumed to start on the first calendar day
    # i.e. Payroll cycle goes from the 1st to 28..31 depending on the Month/Year
    payment_date_consistency = (payroll_month_worked == month_before_payment)

    expect(payment_date_consistency).to eq(payroll.payment_date_consistent?)
  end

  it '-creation is blocked if payment date is too much in the future' do
    expect { payroll = FactoryBot.create(:payroll) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'can be created' do
    print I18n.t('activerecord.models.payroll').capitalize + ': '
    # payroll = FactoryBot.create(:payroll)
    puts payroll.name
  end

  pending '-pending registrations (or changes therein)' do
    # payroll = FactoryBot.create(:payroll)
    registration = FactoryBot.create(:registration)

    puts registration.detailed
  end

  pending 'next payroll can be created' do
    highest_id = Payroll.pluck(:id).max

    payroll = Payroll.find highest_id

    @month_worked = payroll.monthworked + 1.month

    @payday = payroll.paymentdate.to_date + 1.month

    next_payroll = Payroll.create! paymentdate: @payday, monthworked: @month_worked, pap: true

    puts next_payroll
  end

  it '-commentedname' do
    payroll_commented_name = prefix + I18n.l(payroll.monthworked, format: :my)
    payroll_commented_name += ' (' + I18n.l(payroll.paymentdate, format: :compact) + ')'

    expect(payroll_commented_name).to eq payroll.commentedname
  end

  # i.e. payrolls refering to two or more unique months worked exist
  it '#more_than_one_working_month_recorded?' do
    Payroll.num_distinct_working_months > 1

    # To do: use can can (ability) in the future for finer grained Tests
    # e.g. Medical Residence user.
  end

  it '#distinct_working_months' do
    distinct_payroll_working_months = Payroll.pluck(:monthworked).uniq

    expect(distinct_payroll_working_months).to eq Payroll.distinct_working_months

    # To do: can can
  end

  it '#num_distinct_working_months' do
    num_distinct_payroll_working_months = Payroll.distinct_working_months.count

    expect(num_distinct_payroll_working_months).to eq Payroll.num_distinct_working_months

    # To do: can can
  end

  it '#less_than_two_working_months_recorded' do
    Payroll.num_distinct_working_months < 2
  end

  it '#existence?' do
    payroll_existence = Payroll.num_distinct_working_months > 0

    expect(payroll_existence).to eq(Payroll.existence?)
  end

  it 'shortname' do
    payroll_short_name = ''

    payroll_short_name += I18n.l(payroll.monthworked, format: :my)

    payroll_short_name += ' ('
    payroll_short_name += I18n.l(payroll.paymentdate, format: :compact) + ')'

    if payroll.special?
      payroll_short_name += ' *' + I18n.t('activerecord.attributes.payroll.special') + '*'
    end

    expect(payroll_short_name).to eq(payroll.shortname)
  end

  it 'several can be created' do
    created_payrolls = create_list(:payroll, 12, :personal_taxation)
  end

  # Important: it is assumed to be from the 1st of the month to the last
  it '-cycle' do
    payroll_cycle = payroll.start..payroll.finish
    expect(payroll_cycle).to eq payroll.cycle
  end

  # On the specified date
  it '-ids_contextual_on(dt)' do

    contextual_ids = []

    dt_range = dt..dt

    Payroll.all.each do |payroll|

      payroll_start=Dateutils.to_gregorian(payroll.daystarted)
      payroll_finish=Dateutils.to_gregorian(payroll.dayfinished)

      # Alternatively, this could be done:
#      payroll_start=payroll.monthworked.beginning_of_month
#      payroll_finish=payroll.monthworked.end_of_month

      payroll_range = payroll_start..payroll_finish # Payroll Cycle

      next unless Logic.intersect(dt_range, payroll_range) == dt_range

      contextual_ids << payroll.id

    end

    expect(contextual_ids).to eq (Payroll.ids_contextual_on(dt))

  end

  # On the specified date
  it '-ids_contextual_today' do

    today=Date.today

    contextual_ids=Payroll.ids_contextual_on(today)

    expect(contextual_ids).to eq (Payroll.ids_contextual_today)

  end

=begin
  pending '#previous (with 12 months created)' do
    #  if pluck(:monthworked).uniq.count > 1 # i.e. there is more than one month worked

    created_payrolls = create_list(:payroll, 12, :personal_taxation)

    print 'Distinct working months: '
    puts Payroll.num_distinct_working_months
    if Payroll.more_than_one_working_month_recorded?

      puts 'More!!'
      most_recent = []
      #          most_recent << latest_finish_date
      #          before_latest = (pluck(:dayfinished) - most_recent).max
      #          where(dayfinished: before_latest)
    end
  end
=end

end
