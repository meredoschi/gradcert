# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  # To do: review this
  def retroactive_start?
    @status = false

    @status = true if event.start <= Payroll.latestfinishdate

    @status
  end

  def vacation?
    @result = false

    @result = event.leavetype.vacation? if event.leavetype.present?

    @result
  end

  def ongoing?
    !event.archived?
  end

  let(:event) { FactoryBot.create(:event, :absence) }

  # Associations

  it { should belong_to(:annotation) }
  it { should belong_to(:registration) }
  it { should belong_to(:leavetype) }

  # Validations

  it { is_expected.to validate_presence_of(:registration_id) }
  it { is_expected.to validate_presence_of(:start) }
  it { is_expected.to validate_presence_of(:finish) }

  it '-start data may not be created in anticipation (e.g. two months in the future)' do
    expect do
      FactoryBot.create(:event, :absence,
                        :start_two_months_from_now)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  # https://stackoverflow.com/questions/13812717/shoulda-rspec-matchers-conditional-validation

  #   validates :leavetype_id, absence: true, if: :absence?

  context 'absence? (regular absence)' do
    before { allow(subject).to receive(:absence?).and_return(true) }
    it { is_expected.to validate_absence_of(:leavetype_id) }
  end

  context '!absence? (some other event other than a plain absence)' do
    before { allow(subject).to receive(:absence?).and_return(false) }
    it { is_expected.to validate_presence_of(:leavetype_id) }
  end

  it '-start_date_exists?' do
    start_date_existance = Timeliness.parse(event.start)
    expect(start_date_existance).to eq(event.start_date_exists?)
  end

  it '-finish_date_exists?' do
    finish_date_existance = Timeliness.parse(event.finish)
    expect(finish_date_existance).to eq(event.finish_date_exists?)
  end

  it 'absence_or_leavetype_nil?' do
    absence_or_leavetype_missing = (event.absence? || event.leavetype_nil?)
    expect(absence_or_leavetype_missing).to eq(event.absence_or_leavetype_nil?)
  end

  it 'fairly_recent?' do
    threshold = Settings.created_recently.maximum_number_days_ago

    event_recentness = event.created_at < Time.zone.now - threshold

    expect(event_recentness).to eq(event.fairly_recent?)
  end

  # Currently, only one kind of payroll exists so this is not an issue right now.
  # In the future, write more refined tests, according to the ability (permission)
  pending '-starts_after_latest_completed_payroll?' do
    previous_payroll_finish_dt = Payroll.latest_completed.first.finish
  end
  #  validates_date :start, on: :create, after: Payroll.latest_completed.first.finish

  # ...

  it 'can be created' do
    #    print I18n.t('activerecord.models.event').capitalize+': '
    #    event = FactoryBot.create(:event)
    puts event.name
  end

  #  it '#overlaps_payroll(p)' do

  #  end

  # Hotfix 10
  it '-fairly_recent?' do
    threshold = Settings.created_recently.maximum_number_days_ago

    event_recentness = event.created_at < Time.zone.now - threshold

    expect(event_recentness).to eq(event.fairly_recent?)
  end

  it '-archived?' do
    expect(event.archived?).to eq(event.processed)
  end

  it '-ongoing?' do
    expect(event.ongoing?).to eq(!event.processed)
  end

  it 'archived? is true for events already processed' do
    event = FactoryBot.create(:event, :absence, :past)
    expect(event.archived?).to be true
  end

  it 'archived? is false for current events' do
    event = FactoryBot.create(:event, :absence, :current)
    expect(event.archived?).to be false
  end

  it 'ongoing? is true for current events' do
    event = FactoryBot.create(:event, :absence, :current)
    expect(event.ongoing?).to be true
  end

  it 'ongoing? is false for past events (already processed)' do
    event = FactoryBot.create(:event, :absence, :past)
    expect(event.ongoing?).to be false
  end

  # To do: review this
  it 'retroactive_start? is true for events started a year ago' do
    event = FactoryBot.build(:event, :absence, :started_a_year_ago)
    expect(event.retroactive_start?).to be true
  end

  #  it 'a pending event can be created' do

  #    pending_event = FactoryBot.create(:event, :pending)

  #    puts pending_event.details

  #  end
  #  def ongoing?

  #      return !processed

  #  end

  # August - 17
  it '-prefix' do
    event_prefix = if event.leave?

                     I18n.t('activerecord.models.leave').capitalize + ' ' + leavetype.name + ' '

                   else

                     I18n.t('activerecord.attributes.event.absence')

                   end

    expect(event_prefix).to eq(event.prefix)
  end

  it '-name' do
    event_name = event.prefix + ' ' + event.span

    expect(event_name).to eq(event.name)
  end

  # Months spanned from start to finish
  it '-num_additional_months_spanned' do
    # Minimum is 1
    # It is assumed (i.e. validations enforce) that finish is not before start
    future_years_offset = (event.finish.year - event.start.year) * 12
    event_months_spanned = event.finish.month - event.start.month + future_years_offset

    expect(event_months_spanned).to eq(event.num_additional_months_spanned)
  end

  it '-spans_additional_months?' do
    situation = event.num_additional_months_spanned.positive?

    expect(situation).to eq(event.spans_additional_months?)
  end

  it '-occurs_within_the_same_calendar_month?' do
    situation = !event.spans_additional_months?
    expect(situation).to eq(event.occurs_within_the_same_calendar_month?)
  end

  # I18n text
  it '-span' do
    event_span = '(' + I18n.l(event.start, format: :compact)
    event_span += if event.finish.present?

                    ' ' + I18n.t('until') + ' ' + I18n.l(event.finish, format: :compact) + ')'

                  else

                    ')'
                  end

    expect(event_span).to eq(event.span)
  end

  # Start date occured before latest payroll period began
  # i.e. overlaps a previously processed payroll
  it '#ids_started_on_a_previous_payroll' do
    events_started_on_a_previous_payroll = Event.started_on_a_previous_payroll

    event_ids_started_on_a_previous_payroll = events_started_on_a_previous_payroll.pluck(:id)

    expect(event_ids_started_on_a_previous_payroll).to eq Event.ids_started_on_a_previous_payroll
  end

  # Start date occured before latest payroll period began
  # i.e. overlaps a previously processed payroll
  it '#started_on_a_previous_payroll' do
    current_payroll = Payroll.latest.first

    current_payroll_start_date = current_payroll.start
    #    @previous_payroll = Payroll.where(paymentdate: '2017-8-10').first

    @previous_payroll = Payroll.previous.first

    print 'Current payroll start date: '
    puts I18n.l(current_payroll_start_date)

    events_started_on_a_previous_payroll = Event.where('start < ?', current_payroll_start_date)

    expect(events_started_on_a_previous_payroll).to eq Event.started_on_a_previous_payroll
  end
end
