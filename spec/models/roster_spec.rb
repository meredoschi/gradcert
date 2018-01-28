require 'rails_helper'

RSpec.describe Roster, type: :model do
  # single roster
  let(:roster) { roster = FactoryBot.create(:roster) }

  it 'can be created' do
    print I18n.t('activerecord.models.roster').capitalize + ': '
    roster = FactoryBot.create(:roster)
  end

  it { should validate_presence_of(:institution_id) }
  it { should validate_presence_of(:schoolterm_id) }
  it { should validate_presence_of(:dataentrystart)  }
  it { should validate_presence_of(:dataentryfinish) }

  it 'number of authorized supervisors to be created has to be greather than zero' do
    should validate_numericality_of(:authorizedsupervisors)
      .is_greater_than(0)
  end

  it 'start is consistent' do
    start_range = roster.start..roster.start

    start_range.overlaps? roster.schedulerange
  end

  it 'has a name virtual attribute' do
    roster_name = roster.schoolterm.name

    roster_name = roster.institution.name + ' - ' + I18n.t('activerecord.models.schoolterm').capitalize + ' ' + roster.schoolterm.name.downcase

    expect(roster.name).to eq roster_name
  end

  it '-schedulerange' do
    schedule_range = (roster.dataentrystart)..(roster.dataentryfinish) # defined as a range

    expect(schedule_range).to eq(roster.schedulerange)
  end

  it '-schedule' do
    schedule = I18n.t('activerecord.attributes.roster.virtual.schedule').capitalize + ': '

    schedule += I18n.l(roster.dataentrystart) + ' -> ' # textual representation

    schedule += I18n.l(roster.dataentryfinish) # textual representation

    puts schedule

    expect(schedule).to eq(roster.schedule)
  end
end
