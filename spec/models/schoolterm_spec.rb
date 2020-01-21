# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schoolterm, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  let(:schoolterm) { FactoryBot.create(:schoolterm, :pap) }
  let(:medical_residency_schoolterm) { FactoryBot.create(:schoolterm, :medres) }
  let(:undefined_schoolterm) { FactoryBot.create(:schoolterm, :undefined) }
  let(:sep) { Settings.separator + ' ' }
  let(:i18n_from) { I18n.t('from') }
  let(:i18n_to) { I18n.t('to') }
  let(:specified_dt) { Time.zone.today + 1.year }

  ADMISSIONS_PERIOD_I18N = I18n.t\
    'activerecord.attributes.schoolterm.virtual.admissionsdatareportingperiod'

  REGISTRATION_SEASON_I18N = I18n.t('activerecord.attributes.schoolterm.registrationseason')

  context 'constants' do
    it 'ADMISSIONS_PERIOD_I18N' do
      expect(ADMISSIONS_PERIOD_I18N).to eq(Schoolterm::ADMISSIONS_PERIOD_I18N)
    end

    it 'REGISTRATION_SEASON_I18N' do
      expect(REGISTRATION_SEASON_I18N).to eq(Schoolterm::REGISTRATION_SEASON_I18N)
    end
  end

  context 'development-schoolyears' do
    it '-start_finish_dts' do
      schoolterm_start_finish_dts = I18n.l(schoolterm.start) + ' ' + i18n_to + ' ' \
       + I18n.l(schoolterm.finish)
      expect(schoolterm_start_finish_dts).to eq(schoolterm.start_finish_dts)
    end

    it '-registration_period' do
      schoolterm_registration_period = REGISTRATION_SEASON_I18N + ' ' \
      + i18n_from + ' ' + I18n.l(schoolterm.seasondebut) + ' ' + i18n_to \
      + ' ' + I18n.l(schoolterm.seasonclosure)

      expect(schoolterm_registration_period).to eq(schoolterm.registration_period)
    end

    it '-registration_period' do
      schoolterm_registration_period = REGISTRATION_SEASON_I18N + ' ' + i18n_from + \
                                       ' ' + I18n.l(schoolterm.seasondebut) + ' ' + i18n_to + \
                                       ' ' + I18n.l(schoolterm.seasonclosure)

      expect(schoolterm_registration_period).to eq(schoolterm.registration_period)
    end

    it '-admissions_period' do
      schoolterm_admissions_period = ADMISSIONS_PERIOD_I18N + ' ' + i18n_from + ' ' +  \
                                     I18n.l(schoolterm.admissionsdebut) + ' ' + i18n_to + ' ' + \
                                     I18n.l(schoolterm.admissionsclosure)

      expect(schoolterm_admissions_period).to eq(schoolterm.admissions_period)
    end

    it '-details' do
      sep = ' ' + Settings.separator + ' '

      schoolterm_details = schoolterm.start_finish_dts + sep + schoolterm.registration_period \
       + sep + schoolterm.admissions_period

      expect(schoolterm_details).to eq(schoolterm.details)
    end

    # More generic version of active_today
    # specified_dt = specified date
    it '#ids_active_on(specified_dt)' do
      schoolterm_ids_active_on_dt = Schoolterm.contextual_on(specified_dt).pluck(:id).sort.uniq
      expect(schoolterm_ids_active_on_dt).to eq(Schoolterm.ids_active_on(specified_dt))
    end

    # Preferred naming (to avoid confusion with active or inactive registrations)
    # Alias
    it '#ids_contextual_on(specified_dt)' do
      schoolterm_ids_contextual_on_dt = Schoolterm.ids_contextual_on(specified_dt)
      expect(schoolterm_ids_contextual_on_dt).to eq(Schoolterm.ids_active_on(specified_dt))
    end

    it '#ids_active_today' do
      schoolterm_ids_active_on = Schoolterm.ids_active_on(Time.zone.today)
      expect(schoolterm_ids_active_on).to eq(Schoolterm.ids_active_today)
    end

    # Preferred naming (to avoid confusion with active or inactive registrations)
    # Alias
    it '#ids_contextual_today(specified_dt)' do
      schoolterm_ids_contextual_today = Schoolterm.ids_active_today
      expect(schoolterm_ids_contextual_today).to eq(Schoolterm.ids_contextual_today)
    end

    it '#contextual_today(specified_dt)' do
      schoolterms_contextual_today = Schoolterm.contextual_on(Time.zone.today)
      expect(schoolterms_contextual_today).to eq(Schoolterm.contextual_today)
    end

    # Returns latest finish date (i.e. pertaining to the most recent)
    it '#latest_finish_date' do
      schoolterm_latest_finish_dt = Schoolterm.maximum(:finish)
      expect(schoolterm_latest_finish_dt).to eq(Schoolterm.latest_finish_date)
    end

    # Returns earliest finish date (i.e. pertaining to the earliest)
    it '#earliest_finish_date' do
      schoolterm_earliest_finish_dt = Schoolterm.minimum(:finish)
      expect(schoolterm_earliest_finish_dt).to eq(Schoolterm.earliest_finish_date)
    end

    # Registration season open a specified date
    it '#ids_within_registration_season(specified_dt)' do
      schoolterm_ids = Schoolterm.within_registration_season(specified_dt).pluck(:id).sort.uniq
      expect(schoolterm_ids).to eq(Schoolterm.ids_within_registration_season(specified_dt))
    end

    # specified_dt = arbitrary date
    # It is assumed season debut and closure are consistent
    # i.e. have been properly validated and are within start and finish
    it '-within_registration_season?(specified_dt)' do
      is_schoolterm_within_registration_season = ((schoolterm.seasondebut <= specified_dt) \
      && (schoolterm.seasondebut >= specified_dt))
      expect(is_schoolterm_within_registration_season)
        .to eq(schoolterm.within_registration_season?(specified_dt))
    end

    it '#registrations_allowed_and_within_season(specified_dt)' do
      schoolterms_in_season_allowed = Schoolterm.within_registration_season(specified_dt).allowed
      expect(schoolterms_in_season_allowed).to eq(Schoolterm
        .registrations_allowed_and_within_season(specified_dt))
    end

    # Within the registration season

    it '#within_registration_season(specified_dt)' do
      schoolterms_in_season = Schoolterm.within_registration_season(specified_dt)
      expect(schoolterms_in_season).to eq(Schoolterm
        .within_registration_season(specified_dt))
    end

    it '#ids_within_admissions_data_entry_period' do
      schoolterm_ids_within_admissions_data_entry_period = Schoolterm
                                                           .within_admissions_data_entry_period
                                                           .pluck(:id).sort.uniq
      expect(schoolterm_ids_within_admissions_data_entry_period)
        .to eq(Schoolterm.ids_within_admissions_data_entry_period)
    end

    it '#within_admissions_data_entry_period' do
      now = Time.zone.parse('2020-1-1 00:00:01')

      allow(Time).to receive(:now) { now }

      schoolterms_within_admissions_data_entry_period = Schoolterm
                                                        .where('admissionsdebut <= ? AND
                                                          seasonclosure >= ?', now, now)
      expect(schoolterms_within_admissions_data_entry_period)
        .to eq(Schoolterm.within_admissions_data_entry_period)
    end

    # Active today (special case)
    it '#active_today' do
      schoolterms_active_today = Schoolterm.where(id: ids_active_today)
      expect(schoolterms_active_today).to eq(Schoolterm.active_today)
    end

    # Active on a specified date
    it '#active_on(specified_dt)' do
      schoolterms_active_on_dt = Schoolterm.where(id: ids_active_on(specified_dt))
      expect(schoolterms_active_on_dt).to eq(Schoolterm.active_on(specified_dt))
    end
  end

  it 'can be created' do
    FactoryBot.create(:schoolterm, :pap)
    #    print I18n.t('activerecord.models.schoolterm').capitalize+': '
    #    puts schoolterm.name
  end

  it '#in_season? to be true within' do
    pending('program registrations not reviewed yet')
    # ***********************************************************************
    # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

    now = Time.zone.parse('2017-04-28 00:10:00')

    allow(Time).to receive(:now) { now }

    # ***********************************************************************

    start = Settings.registration_season.start

    finish = Settings.registration_season.finish

    registrations_permitted = Logic.within?(start, finish, now) # returs a boolean

    expect(registrations_permitted).to eq true

    #    puts I18n.l(finish)
  end

  it '#in_season? (first attempt) to be false outside' do
    # ***********************************************************************
    # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

    now = Time.zone.parse('2017-5-1 00:00:01')

    allow(Time).to receive(:now) { now }

    # ***********************************************************************

    start = Settings.registration_season.start

    finish = Settings.registration_season.finish

    registrations_permitted = Logic.within?(start, finish, now) # returs a boolean

    expect(registrations_permitted).to eq false

    #  puts I18n.l(finish)
  end

  it 'registration_season_debut' do
    schoolterm = FactoryBot.create(:schoolterm)

    schoolterm_registration_season_debut = schoolterm.seasondebut

    expect(schoolterm_registration_season_debut).to eq(schoolterm.seasondebut)
  end

  # i.e. inside the admissions data entry period (by local admins)
  it '-admissions_data_entry_period?' do
    pending('program admissions not reviewed yet')

    # ***********************************************************************

    schoolterm = FactoryBot.create(:schoolterm)

    dt = (schoolterm.admissionsclosure - 1.day).to_s

    now = Time.zone.parse(dt)
    allow(Time).to receive(:now) { now }

    program_admissions_data_entry_period = false

    if schoolterm.admissionsdebut.present? && schoolterm.admissionsclosure.present?
      program_admissions_data_entry_period = Logic.within?(schoolterm.admissionsdebut,
                                                           schoolterm.admissionsclosure, now)
    end

    expect(program_admissions_data_entry_period).to eq(schoolterm.admissions_data_entry_period?)
  end

  # To do: figure out how to write this test
  it '#admission_ids' do
    pending('program admissions not reviewed yet')

    schoolterms = FactoryBot.create_list(:schoolterm, 5, :pap)

    @ids_within_admissions_data_entry_period = []

    schoolterms.each do |schoolterm|
      puts schoolterm.name

      if schoolterm.admissions_data_entry_period?

        @ids_within_admissions_data_entry_period << schoolterm.id

      end

      puts '@ids_with_editable_admissions: ' + @ids_within_admissions_data_entry_period.to_s

      expect(@ids_within_admissions_data_entry_period).to eq(schoolterms.latest)
    end
  end

  # i.e. inside the admissions data entry period (by local admins)
  it '-admissions_data_entry_period? returns false for date past deadline' do
    # ***********************************************************************

    schoolterm = FactoryBot.create(:schoolterm)

    dt = (schoolterm.admissionsclosure + 2.days).to_s

    now = Time.zone.parse(dt)
    allow(Time).to receive(:now) { now }

    #  puts schoolterm.name

    #    puts now

    expect(schoolterm.admissions_data_entry_period?).to be_falsey
  end

  it '-area' do
    schoolterm_program_area = if schoolterm.pap?
                                I18n.t('activerecord.attributes.program.pap')
                              elsif schoolterm.medres?
                                I18n.t('activerecord.attributes.program.medres')
                              else
                                I18n.t('undefined')
                              end
    expect(schoolterm_program_area).to eq(schoolterm.area)
  end

  it '-area (medical residency)' do
    expect(medical_residency_schoolterm.area)
      .to eq(I18n.t('activerecord.attributes.program.medres'))
  end

  it '-area (undefined)' do
    expect(undefined_schoolterm.area)
      .to eq(I18n.t('undefined'))
  end

  # i.e. inside the admissions data entry period (by local admins)
  pending '-admissions_data_entry_period? returns true on the eve of the deadline' do
    # ***********************************************************************

    schoolterm = FactoryBot.create(:schoolterm)

    dt = (schoolterm.admissionsclosure - 1.day).to_s

    puts schoolterm.details
    now = Time.zone.parse(dt)
    allow(Time).to receive(:now) { now }

    expect(schoolterm.admissions_data_entry_period?).to be_truthy
  end

  it 'registration_season_closure' do
    schoolterm = FactoryBot.create(:schoolterm)

    schoolterm_registration_season_closure = schoolterm.seasonclosure

    expect(schoolterm_registration_season_closure).to eq(schoolterm.seasonclosure)
  end

  it '#in_season? (second attempt) to be true inside range' do
    # ***********************************************************************
    # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

    now = Time.zone.parse('2018-4-30')
    allow(Time).to receive(:now) { now }

    season_debut = '2018-1-5'

    season_closure = '2018-5-1'

    registrations_permitted = Logic.within?(season_debut, season_closure, now) # returs a boolean

    expect(registrations_permitted).to eq true
  end

  it '#in_season? (second attempt) to be false outside range' do
    # ***********************************************************************
    # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

    now = Time.zone.parse('2017-11-30')
    allow(Time).to receive(:now) { now }

    season_debut = '2018-1-5'

    season_closure = '2018-5-1'

    registrations_permitted = Logic.within?(season_debut, season_closure, now) # returs a boolean

    expect(registrations_permitted).to eq false
  end

  it '#in_season? works correctly' do
    # ***********************************************************************
    # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

    now = Time.zone.parse('2017-11-30')
    allow(Time).to receive(:now) { now }

    # ***********************************************************************

    schoolterm = FactoryBot.create(:schoolterm)

    # Schoolterm.latest in reality

    season_debut = '2018-1-5'

    season_closure = '2018-5-1'

    registrations_permitted = Logic.within?(season_debut, season_closure, now) # returs a boolean

    expect(registrations_permitted).to eq schoolterm.in_season?
  end
end
