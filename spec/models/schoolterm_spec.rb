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

    @program_admissions_data_entry_period = false

    if schoolterm.admissionsdebut.present? && schoolterm.admissionsclosure.present?
      @program_admissions_data_entry_period = Logic.within?(schoolterm.admissionsdebut,
                                                            schoolterm.admissionsclosure, now)
    end

    expect(@program_admissions_data_entry_period).to eq(schoolterm.admissions_data_entry_period?)
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
