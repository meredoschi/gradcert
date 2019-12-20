# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payroll, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  let(:payroll) { FactoryBot.create(:payroll, :personal_taxation) }

  let(:taxation) { FactoryBot.create(:taxation, :personal) }
  let(:dt) { Date.today - 60 }
  #  let(:admission) { FactoryBot.create(:admission, :zero_amounts) }

  MAX_COMMENT_LEN = Settings.maximum_comment_length.payroll

  context 'associations' do
    it { is_expected.to belong_to(:scholarship) }
    it { is_expected.to belong_to(:taxation) }
    it { is_expected.to have_many(:annotation).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:bankpayment) }
    it { is_expected.to have_many(:feedback) }
  end

  context 'validations' do
    it { is_expected.to validate_length_of(:comment).is_at_most(MAX_COMMENT_LEN) }
    context 'required fields' do
      it { is_expected.to validate_presence_of(:paymentdate) }
      it { is_expected.to validate_presence_of(:taxation_id) }
      it { is_expected.to validate_presence_of(:monthworked) }
    end
  end

  context 'class methods' do
    context 'working months' do
      # The date when the most recent payroll cycle theoretically started
      # Even if the actual payroll information hasn't been entered in the system yet
      #
      it '#start_dt_corresponding_to_today' do
        current_month_worked = Date.today.beginning_of_month
        # IMPORTANT! The payroll cycle goes from the first to the last calendar day in every month.

        expect(current_month_worked).to eq Payroll.start_dt_corresponding_to_today

        # To do: can can
      end

      it '#distinct_working_months' do
        distinct_payroll_working_months = Payroll.pluck(:monthworked).uniq

        expect(distinct_payroll_working_months).to eq Payroll.distinct_working_months

        # To do: can can
      end

      it '#existence?' do
        payroll_existence = Payroll.num_distinct_working_months > 0

        expect(payroll_existence).to eq(Payroll.existence?)
      end

      it '#num_distinct_working_months' do
        num_distinct_payroll_working_months = Payroll.distinct_working_months.count

        expect(num_distinct_payroll_working_months).to eq Payroll.num_distinct_working_months

        # To do: can can
      end

      it '#less_than_two_working_months_recorded?' do
        status = Payroll.num_distinct_working_months < 2
        expect(status).to eq(Payroll.less_than_two_working_months_recorded?)
      end

      # i.e. payrolls refering to two or more unique months worked exist
      it '#more_than_one_working_month_recorded?' do
        status = Payroll.num_distinct_working_months > 1

        expect(status).to eq(Payroll.more_than_one_working_month_recorded?)
        # To do: use can can (ability) in the future for finer grained Tests
        # e.g. Medical Residence user.
      end
    end

    context 'Contextual' do
      # On the specified date
      it '#ids_contextual_on(dt)' do
        contextual_ids = []

        dt_range = dt..dt

        Payroll.all.each do |payroll|
          payroll_start = Dateutils.to_gregorian(payroll.daystarted)
          payroll_finish = Dateutils.to_gregorian(payroll.dayfinished)

          # Alternatively, this could be done:
          #      payroll_start=payroll.monthworked.beginning_of_month
          #      payroll_finish=payroll.monthworked.end_of_month

          payroll_range = payroll_start..payroll_finish # Payroll Cycle

          next unless Logic.intersect(dt_range, payroll_range) == dt_range

          contextual_ids << payroll.id
        end

        expect(contextual_ids).to eq Payroll.ids_contextual_on(dt)
      end

      # On the specified date
      it '#ids_contextual_today' do
        today = Date.today

        contextual_ids = Payroll.ids_contextual_on(today)

        expect(contextual_ids).to eq Payroll.ids_contextual_today
      end

      # Contextual on a specified date - returns an active record relation
      # Only one payroll, per area, should exist.
      # Reminder: use .first to get the object
      it '#contextual_on(dt)' do
        payrolls_contextual_on_dt = Payroll.where(id: Payroll.ids_contextual_on(dt))
        expect(payrolls_contextual_on_dt).to eq(Payroll.contextual_on(dt))
      end

      it '#contextual_today' do
        payrolls_contextual_today = Payroll.where(id: Payroll.ids_contextual_today)
        expect(payrolls_contextual_today).to eq(Payroll.contextual_today)
      end

      # Returns an active record relation
      it '#current' do
        current_payrolls = Payroll.contextual_today
        expect(current_payrolls).to eq(Payroll.current)
      end
    end

    context 'Timeline' do
      it '#past' do
        possible_current_payrolls = Payroll.current

        previous_payrolls = nil

        if possible_current_payrolls.present? # not nil

          # It is assumed payrolls are either of type pap or medical residency (but not both)
          # Future to do: add gradcert (boolean field) to the model
          current_payroll = possible_current_payrolls.first
          current_month_worked = current_payroll.monthworked
          previous_payrolls = Payroll.where('monthworked < ?', current_month_worked)

        end

        expect(previous_payrolls).to eq(Payroll.past)
      end

      # Not in effect yet, scheduled for future payroll cycles
      it '#planned' do
        subsequently_scheduled_payrolls = Payroll.where('monthworked > ?',
                                                        Payroll.start_dt_corresponding_to_today)
        expect(subsequently_scheduled_payrolls).to eq(Payroll.planned)
      end

      # Current or past (already closed)
      it '#actual' do
        actual_payrolls = Payroll.where.not(id: Payroll.planned)
        expect(actual_payrolls).to eq(Payroll.actual)
      end

      # Most recent "monthworked" or farthest in the future (if already in the system)
      # Returns a date object
      it '#reference_month_most_in_the_future' do
        reference_month_most_in_the_future = Payroll.order(monthworked: :desc).first.monthworked
        expect(reference_month_most_in_the_future).to eq(Payroll.reference_month_most_in_the_future)
      end

      # Returns an active record relation
      it '#with_reference_month_most_in_the_future' do
        with_reference_month_most_in_the_future = Payroll.where(monthworked: Payroll
          .reference_month_most_in_the_future)
        expect(with_reference_month_most_in_the_future)
          .to eq(Payroll.with_reference_month_most_in_the_future)
      end
    end
  end

  context 'instance methods' do
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

  it '-dataentryperiod' do
    # payroll = FactoryBot.create(:payroll)

    dataentryperiod = payroll.dataentrystart..payroll.dataentryfinish

    expect(payroll.dataentryperiod).to eq(dataentryperiod)
  end

  it '-prefix' do
    special_prefix = ''

    if payroll.special?
      special_prefix = '*' + I18n.t('activerecord.attributes.payroll.special') + \
                       ' *  [' + payroll.comment + '] '
    end

    expect(special_prefix).to eq(payroll.prefix)
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

  it '-creation is blocked if payment date is too far in the future' do
    expect { FactoryBot.create(:payroll) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'can be created' do
    print I18n.t('activerecord.models.payroll').capitalize + ': '
    # payroll = FactoryBot.create(:payroll)
    puts payroll.name
  end

  #  pending '-pending registrations (or changes therein)' do
  # payroll = FactoryBot.create(:payroll)
  #    registration = FactoryBot.create(:registration)

  #    puts registration.detailed
  #  end

  it 'next payroll can be created' do
    highest_id = Payroll.pluck(:id).max

    payroll = Payroll.find highest_id

    @month_worked = payroll.monthworked + 1.month

    @payday = payroll.paymentdate.to_date + 1.month

    next_payroll = Payroll.create! paymentdate: @payday,
                                   monthworked: @month_worked, pap: true, taxation_id: taxation.id

    puts next_payroll
  end

  it 'shortname' do
    payroll = FactoryBot.create(:payroll, :personal_taxation, :special)

    payroll_short_name = I18n.l(payroll.monthworked, format: :my) \
    + ' (' + I18n.l(payroll.paymentdate, format: :compact) + ')'

    if payroll.special?
      payroll_short_name += ' *' + I18n.t('activerecord.attributes.payroll.special') + '*'
    end

    expect(payroll_short_name).to eq(payroll.shortname)
  end

  it 'several can be created' do
    12.times { FactoryBot.create(:payroll, :personal_taxation) }
  end

  # Important: it is assumed to be from the 1st of the month to the last
  it '-cycle' do
    payroll_cycle = payroll.start..payroll.finish
    expect(payroll_cycle).to eq payroll.cycle
  end

  #   pending '#previous (with 12 months created)' do
  #     #  if pluck(:monthworked).uniq.count > 1 # i.e. there is more than one month worked
  #
  #     created_payrolls = create_list(:payroll, 12, :personal_taxation)
  #
  #     print 'Distinct working months: '
  #     puts Payroll.num_distinct_working_months
  #     if Payroll.more_than_one_working_month_recorded?
  #
  #       puts 'More!!'
  #       most_recent = []
  #       #          most_recent << latest_finish_date
  #       #          before_latest = (pluck(:dayfinished) - most_recent).max
  #       #          where(dayfinished: before_latest)
  #     end
  #   end
end
