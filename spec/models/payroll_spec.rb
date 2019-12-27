# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payroll, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  let!(:payroll) { FactoryBot.create(:payroll, :personal_taxation) }
  let!(:taxation) { FactoryBot.create(:taxation, :personal) }

  let(:dt) { Time.zone.today - 60 }
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

    context 'date consistency' do
      it '-payment_on_the_usual_dt?' do
        customary_payment_dt = payroll.monthworked + \
                               Settings.payroll.payday.days_following_month_worked.days + 1.month

        is_payment_on_the_customary_dt = payroll.paymentdate == customary_payment_dt

        expect(is_payment_on_the_customary_dt).to eq(payroll.payment_on_the_usual_dt?)
      end

      pending 'payment must be on the customary date' do
        expect { FactoryBot.create(:payroll, :personal_taxation, :late_payment) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'class methods' do
    context 'working months' do
      # The date when the most recent payroll cycle theoretically started
      # Even if the actual payroll information hasn't been entered in the system yet
      #
      it '#start_dt_corresponding_to_today' do
        current_month_worked = Time.zone.today.beginning_of_month
        # IMPORTANT! The payroll cycle goes from the first to the last calendar day in every month.

        expect(current_month_worked).to eq Payroll.start_dt_corresponding_to_today

        # To do: can can
      end

      it '#distinct_working_months' do
        distinct_payroll_working_months = Payroll.uniq.pluck(:monthworked)

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
      it '#ids_contextual_on_sql(dt)' do
        # Date represented in numeric format
        numeric_dt = Dateutils.regular_to_elapsed(dt)

        # Filter payrolls yet to start as well as those already completed
        query = 'select id from payrolls where id not in '\
        '(Select id from payrolls where daystarted > ? or dayfinished<?)'

        # This is written in plural form, for occasionally there may be special payrolls.
        # There should be at most one regular payroll per program area (e.g. medical residency).
        matching_payroll_ids = Payroll.find_by_sql [query, numeric_dt, numeric_dt]

        expect(matching_payroll_ids).to eq Payroll.ids_contextual_on_sql(dt)
      end

      it '#contextual_on_sql(dt)' do
        # Date represented in numeric format
        numeric_dt = Dateutils.regular_to_elapsed(dt)

        # Filter payrolls yet to start as well as those already completed
        query = 'select * from payrolls where id not in '\
        '(Select id from payrolls where daystarted > ? or dayfinished<?)'

        # This is written in plural form, for occasionally there may be special payrolls.
        # There should be at most one regular payroll per program area (e.g. medical residency).
        matching_payrolls = Payroll.find_by_sql [query, numeric_dt, numeric_dt]

        expect(matching_payrolls).to eq Payroll.contextual_on_sql(dt)
      end

      it '#ids_contextual_sql(dt)' do
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

      # On the specified date (active record version)
      it '#ids_contextual_on_active_rec(dt)' do
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
        today = Time.zone.today

        contextual_ids = Payroll.ids_contextual_on(today)

        expect(contextual_ids).to eq Payroll.ids_contextual_today
      end

      # Contextual on a specified date - returns an active record relation
      # Only one payroll, per area, should exist.
      # Reminder: use .first to get the object
      it '#contextual_on(dt)' do
        payrolls_contextual_on_dt = Payroll.where(id: Payroll.ids_contextual_on_sql(dt))

        #    payrolls_contextual_on_dt = Payroll.contextual_on_sql(dt)

        expect(payrolls_contextual_on_dt).to eq(Payroll.contextual_on(dt))
      end

      it '#contextual_on_active_rec(dt)' do
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
      # Last day of the payroll which is most in the future
      it '#farthestaccountabledate_activerec' do
        farthest_accountable_dt = Dateutils.elapsed_to_regular_date(Payroll.maximum(:dayfinished))
        expect(farthest_accountable_dt).to eq(Payroll.farthestaccountabledate_activerec)
      end

      it '#farthestaccountabledate is an alias to farthestaccountabledate_sql' do
        farthest_accountable_dt = Payroll.farthestaccountabledate_sql
        expect(farthest_accountable_dt).to eq(Payroll.farthestaccountabledate)
      end

      it '#farthestaccountabledate_sql' do
        result = nil

        if Payroll.count > 0

          query = 'WITH max_dt(monthworked) AS (Select monthworked from payrolls '\
          'order by monthworked desc limit 1), farthest_finish(tm) as('\
          "select monthworked + interval '1 month' - interval '1 day' from max_dt)"\
          'select tm::date as farthest_calculable_payroll_dt from farthest_finish'
          result = ActiveRecord::Base.connection.execute(query).values[0][0].to_date
        end

        expect(result).to eq(Payroll.farthestaccountabledate_sql)
      end

      it '#past_ids_sql' do
        # Date represented in numeric format
        numeric_dt = Dateutils.regular_to_elapsed(Time.zone.today)

        # Filter payrolls yet to start as well as those already completed
        query = 'select id from payrolls where id in (Select id from payrolls where dayfinished<?)'

        # i.e. finish date has passed, but not necessarily completed (bank payment performed)
        past_payroll_ids = Payroll.find_by_sql [query, numeric_dt]

        expect(past_payroll_ids).to eq Payroll.past_ids_sql
      end

      it '#past' do
        past_payrolls = Payroll.where(id: Payroll.past_ids_sql)
        expect(past_payrolls).to eq(Payroll.past)
      end

      it '#past_active_rec' do
        possible_current_payrolls = Payroll.current

        previous_payrolls = nil

        if possible_current_payrolls.present? # not nil

          # It is assumed payrolls are either of type pap or medical residency (but not both)
          # Future to do: add gradcert (boolean field) to the model
          current_payroll = possible_current_payrolls.first
          current_month_worked = current_payroll.monthworked
          previous_payrolls = Payroll.where('monthworked < ?', current_month_worked)

        end

        expect(previous_payrolls).to eq(Payroll.past_active_rec)
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

    context 'ordering' do
      it '#newest_first' do
        payrolls_ordered_by_day_finished_desc = Payroll.order(dayfinished: :desc).uniq
        expect(payrolls_ordered_by_day_finished_desc).to eq Payroll.newest_first
      end

      it '#ordered_from_oldest_to_newest' do
        payrolls_ordered_from_oldest_to_newest = Payroll.order(dayfinished: :asc).uniq
        expect(payrolls_ordered_from_oldest_to_newest).to eq Payroll.ordered_from_oldest_to_newest
      end

      # Alias
      it '#ordered_by_most_recent' do
        payrolls_ordered_by_most_recent = Payroll
                                          .ordered_by_monthworked_paymentdate_special_createdat_desc
        expect(payrolls_ordered_by_most_recent)
          .to eq(Payroll.ordered_by_most_recent)
      end

      it '#ordered_by_reference_month_desc' do
        payrolls_ordered_by_reference_month_desc = Payroll.order(monthworked: :desc)
        expect(payrolls_ordered_by_reference_month_desc).to eq(Payroll
          .ordered_by_reference_month_desc)
      end

      it '#ordered_by_monthworked_paymentdate_special_createdat_desc' do
        payrolls_in_descending_paymentdate_order = Payroll.order(monthworked: :desc,
                                                                 paymentdate: :desc,
                                                                 special: :desc, created_at: :desc)
        expect(payrolls_in_descending_paymentdate_order)
          .to eq(Payroll.ordered_by_monthworked_paymentdate_special_createdat_desc)
      end

      it '#ordered_by_reference_month' do
        payrolls_ordered_by_reference_month = Payroll.order(monthworked: :asc)
        expect(payrolls_ordered_by_reference_month).to eq(Payroll.ordered_by_reference_month)
      end

      # i.e. with the most recent (or most in the future) finish date
      it '#newest' do
        newest_payrolls = Payroll.order(:dayfinished).last
        expect(newest_payrolls).to eq(Payroll.newest)
      end
    end

    context 'situation' do
      it '#with_bankpayment' do
        payrolls_with_bankpayment = Payroll.joins(:bankpayment).uniq
        expect(payrolls_with_bankpayment).to eq(Payroll.with_bankpayment)
      end

      # Closed, bank payment performed.
      it '#without_bankpayment' do
        payrolls_without_bankpayment = Payroll.where.not(id: Payroll.with_bankpayment)
        expect(payrolls_without_bankpayment).to eq(Payroll.without_bankpayment)
      end

      it '#with_annotations' do
        payrolls_with_annotations = Payroll.joins(:annotation).uniq
        expect(payrolls_with_annotations).to eq(Payroll.with_annotations)
      end

      # Dec 2017
      # Obs: returns an activerecord relation
      # This may return nil if payrolls are created in advance of the cycle
      # (since they, logically, will not be completed yet)
      it '#latest_completed' do
        latest_completed_payroll = Payroll.latest_completed_sql
        expect(latest_completed_payroll).to eq(Payroll.latest_completed)
      end

      it '#latest_completed_sql' do
        query = 'WITH Completed_Payrolls_CTE(monthworked, paymentdate) '\
        'AS (select p.monthworked, p.paymentdate from payrolls p inner join bankpayments bp on'\
        '(p.id=bp.payroll_id) where bp.done=true)'\
        ','\
        'Latest_Completed_Payroll_CTE(monthworked, paymentdate) AS ('\
        'select * from Completed_Payrolls_CTE order by monthworked desc, paymentdate desc limit 1'\
        '),'\
        'Latest_Completed_Payroll_monthworked_CTE(monthworked) AS ('\
        'select monthworked from Latest_Completed_Payroll_CTE'\
        '),'\
        'Latest_Completed_Payroll_paymentdate_CTE(paymentdate) AS ('\
        'select paymentdate from Latest_Completed_Payroll_CTE'\
        ')'\
        'select * from Payrolls where monthworked '\
        'in (select monthworked from Latest_Completed_Payroll_monthworked_CTE) and '\
        'paymentdate in (select paymentdate from Latest_Completed_Payroll_paymentdate_CTE);'

        latest_completed = Payroll.find_by_sql(query)
        expect(latest_completed).to eq(Payroll.latest_completed_sql)
      end

      it '#previous' do
        query = 'WITH Completed_Payrolls_CTE(monthworked, paymentdate) AS '\
        '(select p.monthworked, p.paymentdate from payrolls p inner join bankpayments bp on '\
        '(p.id=bp.payroll_id) where bp.done=true)'\
        ','\
        'Latest_Completed_Payroll_CTE(monthworked, paymentdate) AS ('\
        'select * from Completed_Payrolls_CTE order by monthworked desc, paymentdate desc limit 1'\
        '),'\
        'Latest_Completed_Payroll_monthworked_CTE(monthworked) AS ('\
        'select monthworked from Latest_Completed_Payroll_CTE'\
        ')'\
        'select * from Payrolls p where monthworked in '\
        '(select monthworked from Latest_Completed_Payroll_monthworked_CTE) and p.special=false;'

        previous_payroll = Payroll.find_by_sql(query)
        expect(previous_payroll).to eq(Payroll.previous)
      end

      # Closed, bank payment performed.
      it '#completed' do
        completed_payrolls = Payroll.joins(:bankpayment).merge(Bankpayment.done)
        expect(completed_payrolls).to eq(Payroll.completed)
      end

      # Closed, bank payment performed.
      it '#incomplete' do
        incomplete_payrolls = Payroll.joins(:bankpayment).merge(Bankpayment.not_done)
        expect(incomplete_payrolls).to eq(Payroll.incomplete)
      end

      it '#active' do
        active_payrolls = Payroll.contextual_today.incomplete
        expect(active_payrolls).to eq(Payroll.contextual_today.incomplete)
      end

      # Find the information using raw sql (less portable, but generally faster than active record)
      # Provided for convenience
      it '#annotated_ids_sql' do
        # sql query
        query = 'SELECT distinct p.id FROM payrolls p INNER JOIN annotations a '\
        'ON (p.id = a.payroll_id);'
        annotated_ids_sql = Payroll.find_by_sql(query)
        expect(annotated_ids_sql).to eq(Payroll.annotated_ids_sql)
      end

      it '#not_annotated_ids_sql' do
        # sql query
        query = 'select id from payrolls p2 where id not in '\
        ' (SELECT distinct p.id FROM payrolls p ' \
        ' INNER JOIN annotations a ON (p.id = a.payroll_id));'
        payroll_ids_without_annotations = Payroll.find_by_sql(query)
        expect(payroll_ids_without_annotations).to eq(Payroll.not_annotated_ids_sql)
      end

      # Returns the ids for those payrolls with at least one annotation (via active record)
      it '#annotated_ids' do
        annotated_payroll_ids = Payroll.joins(:annotation).pluck(:id).uniq
        expect(annotated_payroll_ids).to eq(Payroll.annotated_ids_sql)
      end

      it '#annotated_ids and annotated_ids_sql return the same results' do
        expect(Payroll.annotated_ids).to eq(Payroll.annotated_ids_sql)
      end

      # Returns payrolls with at least one annotation
      it '#annotated' do
        # annotated_payrolls = Payroll.where(id: Payroll.annotated_ids) # active record version
        annotated_payrolls = Payroll.where(id: Payroll.annotated_ids_sql) # calls the sql version
        expect(annotated_payrolls).to eq(Payroll.annotated)
      end

      # Not calculated yet.
      it '#not_annotated' do
        payrolls_without_annotations = Payroll.where.not(id: Payroll.annotated)
        expect(payrolls_without_annotations).to eq(Payroll.not_annotated)
      end

      # Alias to completed
      it '#done' do
        payrolls_done = Payroll.completed
        expect(payrolls_done).to eq(Payroll.done)
      end

      it '#not_scheduled' do
        payrolls_not_scheduled_to_be_paid_yet = Payroll.where.not(id: Payroll.with_bankpayment)
        expect(payrolls_not_scheduled_to_be_paid_yet).to eq(Payroll.not_scheduled)
      end

      context 'kind' do
        # i.e. where special is not true (false or
        it '#regular' do
          regular_payrolls = Payroll.where(special: false)
          expect(regular_payrolls).to eq(Payroll.regular)
        end

        it '#special' do
          special_payrolls = Payroll.where(special: true)
          expect(special_payrolls).to eq(Payroll.special)
        end

        it '#pap' do
          pap_payrolls = Payroll.where(pap: true, medres: false)
          expect(pap_payrolls).to eq(Payroll.pap)
        end

        it '#medres' do
          medres_payrolls = Payroll.where(medres: true, pap: false)
          expect(medres_payrolls).to eq(Payroll.medres)
        end
      end
    end
  end

  context 'instance methods' do
    context 'creation' do
      it 'can be created' do
        FactoryBot.create(:payroll, :personal_taxation)
      end

      it 'several can be created' do
        12.times { FactoryBot.create(:payroll, :personal_taxation) }
      end

      it 'next payroll can be created' do
        highest_id = Payroll.pluck(:id).max

        payroll = Payroll.find highest_id

        month_worked = payroll.monthworked + 1.month

        payday = payroll.paymentdate.to_date + 1.month

        Payroll.create! paymentdate: payday, monthworked: month_worked,
                        taxation_id: taxation.id, pap: true
      end

      it '-creation is blocked if payment date is too far in the future' do
        expect { FactoryBot.create(:payroll) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'boolean' do
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

      it 'payment_date_consistent?' do
        payroll_month_worked = payroll.monthworked.beginning_of_month
        month_before_payment = payroll.paymentdate.beginning_of_month.last_month

        # IMPORTANT: Working month is assumed to start on the first calendar day
        # i.e. Payroll cycle goes from the 1st to 28..31 depending on the Month/Year
        payment_date_consistency = (payroll_month_worked == month_before_payment)

        expect(payment_date_consistency).to eq(payroll.payment_date_consistent?)
      end

      it 'medres? is false for PAP payroll' do
        payroll = FactoryBot.create(:payroll, :personal_taxation) # default is PAP

        expect(payroll.medres?).to be false
      end

      it 'medres? is true for Medical Residency payroll' do
        payroll = FactoryBot.create(:payroll, :personal_taxation, :medres) # default is PAP

        expect(payroll.medres?).to be true
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
    end
  end

  it '-sector' do
    payroll_sector = I18n.t('activerecord.attributes.payroll.pap') if payroll.pap?

    payroll_sector = I18n.t('activerecord.attributes.payroll.medres') if payroll.medres?

    expect(payroll_sector).to eq payroll.sector
    #    payroll_sector
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
    payroll_range = payroll.range
    expect(payroll.range).to eq(payroll_range)
  end

  it '-dataentrypermitted?' do
    start = payroll.dataentrystart

    finish = payroll.dataentryfinish

    right_now = Time.zone.now

    data_entry_permitted = Logic.within?(start, finish, right_now) # returs a boolean

    expect(payroll.dataentrypermitted?).to eq(data_entry_permitted)
  end

  #  pending '-pending registrations (or changes therein)' do
  # payroll = FactoryBot.create(:payroll)
  #    registration = FactoryBot.create(:registration)

  #    puts registration.detailed
  #  end

  it 'shortname' do
    payroll = FactoryBot.create(:payroll, :personal_taxation, :special)

    payroll_short_name = I18n.l(payroll.monthworked, format: :my) \
    + ' (' + I18n.l(payroll.paymentdate, format: :compact) + ')'

    if payroll.special?
      payroll_short_name += ' *' + I18n.t('activerecord.attributes.payroll.special') + '*'
    end

    expect(payroll_short_name).to eq(payroll.shortname)
  end

  # Important: it is assumed to be from the 1st of the month to the last
  it '-cycle' do
    payroll_cycle = payroll.start..payroll.finish
    expect(payroll_cycle).to eq payroll.cycle
  end

  it 'done alias to done?' do
    is_payroll_done = payroll.done?

    expect(is_payroll_done).to eq(payroll.done)
  end

  it '-done?' do
    is_payroll_done = if payroll.bankpayment.exists? && payroll.bankpayment.done == true
                        true
                      else
                        false
                      end

    expect(is_payroll_done).to eq(payroll.done?)
  end

  it '-regular?' do
    is_payroll_regular = payroll.regular?
    expect(is_payroll_regular).to eq(payroll.regular?)
  end

  it '-with_events?' do
    is_payroll_with_events = payroll.events.exists?
    expect(is_payroll_with_events).to eq(payroll.with_events?)
  end

  it '-confirmed?' do
    is_payroll_confirmed = !payroll.pending?
    expect(is_payroll_confirmed).to eq(payroll.confirmed?)
  end

  it '-completed? (alias to done?)' do
    is_payroll_completed = payroll.done
    expect(is_payroll_completed).to eq(payroll.completed?)
  end

  it '-incomplete?' do
    is_payroll_incomplete = !payroll.done?
    expect(is_payroll_incomplete).to eq(payroll.incomplete?)
  end

  it '-with_bankpayment?' do
    is_payroll_with_bankpayment = payroll.bankpayment.exists?
    expect(is_payroll_with_bankpayment).to eq(payroll.with_bankpayment?)
  end

  it '-without_bankpayment?' do
    is_payroll_without_bankpayment = !payroll.with_bankpayment?
    expect(is_payroll_without_bankpayment).to eq(payroll.without_bankpayment?)
  end

  it '-details' do
    month_worked_i18n = I18n.t('activerecord.attributes.payroll.monthworked')
    payment_date_i18n = I18n.t('activerecord.attributes.payroll.paymentdate')
    amount_i18n = I18n.t('activerecord.attributes.payroll.amount')
    special_i18n = I18n.t('activerecord.attributes.payroll.special')
    sep = Settings.separator + ' '
    payroll_details = '[' + payroll.id.to_s + ']' + sep + \
                      month_worked_i18n + ': ' + I18n.l(payroll.monthworked) + sep + \
                      payment_date_i18n + ': ' + I18n.l(payroll.paymentdate) + sep + \
                      amount_i18n + ': ' + payroll.amount_cents.to_s + sep + \
                      special_i18n + ': ' + payroll.special.to_s
    expect(payroll_details).to eq(payroll.details)
  end
end
