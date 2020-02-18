# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schoolyear, type: :model do
  let(:year) { 1 }
  let(:institution) { FactoryBot.create(:institution) }
  let(:identifier) { institution.id }
  let(:program) { FactoryBot.create(:program, :biannual) }
  let(:programname) { FactoryBot.create(:programname) }
  let(:programid) { program.id }

  let(:schoolyear) { FactoryBot.create(:schoolyear, :freshman, program_id: program.id) }

  let(:schoolterm) { FactoryBot.create(:schoolterm, :pap) }

  let(:specified_dt) { Time.zone.today + 4.months }

  let(:MAX_YEARS) { Program::MAX_YEARS }

  # Even Medical Residency training will not have this many years, in general.
  let(:programyear_too_high) { 7 }

  context 'creation' do
    it 'can be created' do
      #  print I18n.t('activerecord.models.schoolyear').capitalize + ': '
      #  schoolyear = FactoryBot.create(:schoolyear, :freshman)
      puts schoolyear.info
      FactoryBot.create(:schoolyear, :freshman)

      #  puts schoolyear.info
    end
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:practice) }
    it { is_expected.to validate_presence_of(:theory) }
    it { is_expected.to validate_presence_of(:programyear) }

    it { is_expected.to validate_numericality_of(:practice).only_integer }
    it { is_expected.to validate_numericality_of(:practice).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:practice).is_less_than_or_equal_to(8784) }

    it { is_expected.to validate_numericality_of(:theory).only_integer }
    it { is_expected.to validate_numericality_of(:theory).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:theory).is_less_than_or_equal_to(8784) }

    it { is_expected.to validate_numericality_of(:programyear).only_integer }
    it { is_expected.to validate_numericality_of(:programyear).is_greater_than_or_equal_to(1) }
    it {
      is_expected.to validate_numericality_of(:programyear)
        .is_less_than_or_equal_to(Program::MAX_YEARS)
    }

    it '-creation is blocked when programyear is higher than the program duration' do
      programyear_i18n = I18n.t('activerecord.attributes.schoolyear.programyear')

      msg = I18n.t('validation_failed') + ': ' + programyear_i18n + ' ' + I18n
            .t('activerecord.errors.models.schoolyear.attributes'\
              '.programyear.exceeds_program_duration')

      expect do
        FactoryBot.create(:schoolyear, :freshman, programyear: 7)
        # https://stackoverflow.com/questions/45128434/comparing-rspec-custom-activerecordrecordinvalid-errors-messages
      end .to raise_error(ActiveRecord::RecordInvalid, msg)
    end
  end

  context 'Instance methods' do
    it '-identifier_i18n' do
      identifier_i18n_txt = I18n.t('activerecord.attributes.schoolyears.id')\
                                .capitalize + ' [ ' + schoolyear.id.to_s + ' ]'

      expect(identifier_i18n_txt).to eq schoolyear.identifier_i18n
    end

    it '-theory_i18n' do
      theory_i18n_txt = I18n.t('activerecord.attributes.schoolyears.theory')\
                            .capitalize + ': ' + schoolyear.theory.to_s
      expect(theory_i18n_txt).to eq schoolyear.theory_i18n
    end

    it '-workload_i18n' do
      workload_i18n = schoolyear.theory_i18n + Pretty.sep + ' ' + schoolyear.practice_i18n

      expect(workload_i18n).to eq schoolyear.workload_i18n
    end

    it '-practice_i18n' do
      practice_i18n_txt = I18n.t('activerecord.attributes.schoolyears.practice')\
                              .capitalize + ': ' + schoolyear.practice.to_s
      expect(practice_i18n_txt).to eq schoolyear.practice_i18n
    end

    it '-programyear_id_i18n' do
      programyear_id_i18n = I18n.t('activerecord.attributes.schoolyears.programyear')\
                                .capitalize + ' [ ' + schoolyear.programyear.to_s + ' ]'
      expect(programyear_id_i18n).to eq(schoolyear.programyear_id_i18n)
    end

    it '-ordinal_year_i18n' do
      schoolyear_ordinal_year_i18n = schoolyear.ordinalyr + ' ' + I18n.t('year')
      expect(schoolyear_ordinal_year_i18n).to eq(schoolyear.ordinal_year_i18n)
    end

    #       Program year ordinal
    it '-ordinalyr' do
      schoolyear_ordinal_year = schoolyear.programyear.to_s + Pretty.ordinal_suffix
      expect(schoolyear_ordinal_year).to eq(schoolyear.ordinalyr)
    end

    #   # Created for 2018 registration season (rake task)
    #
    it '-details' do
      schoolyear_details = schoolyear.ordinalyr + ' ' + I18n.t('activerecord.models.schoolyears')\
       + ' [ id : ' + schoolyear.id.to_s + ' ]'
      expect(schoolyear_details).to eq(schoolyear.details)
    end

    it '-first_year?' do
      schoolyear_is_first = (schoolyear.programyear == 1)
      expect(schoolyear_is_first).to eq schoolyear.first_year?
    end

    it '-workload' do
      schoolyear_workload = schoolyear.theory
      expect(schoolyear_workload).to eq(schoolyear.workload)
    end

    # shorthand for programyear number (1 first, 2 second, 3 third and so forth)
    it '-level' do
      schoolyear_level = schoolyear.programyear

      expect(schoolyear_level).to eq schoolyear.level
    end
  end

  it '-info' do
    sep = Pretty.sep

    schoolyear_info2 = schoolyear.identifier_i18n + sep + ' ' + \
                       schoolyear.program_id_i18n + sep + ' ' + \
                       schoolyear.programyear_id_i18n + sep + ' ' + \
                       schoolyear.workload_i18n

    expect(schoolyear_info2).to eq(schoolyear.info)
  end

  it '-name' do
    schoolyear_name = schoolyear.program_name
    expect(schoolyear_name).to eq(schoolyear.name)
  end

  it '-program_name' do
    schoolyear_program_name = schoolyear.programyear.to_s\
     + Pretty.ordinal_suffix + ' ' + schoolyear.program.name

    expect(schoolyear_program_name).to eq(schoolyear.program_name)
  end

  it '-program_sector' do
    schoolyear_program_sector = schoolyear.program.sector
    expect(schoolyear_program_sector).to eq(schoolyear.program_sector)
  end

  it '-sector_i18n' do
    schoolyear_program_sector_i18n = I18n.t('definitions.schoolyear.sector_prefix'\
       + '.' + schoolyear.program_sector)
    expect(schoolyear_program_sector_i18n).to eq(schoolyear.sector_i18n)
  end

  #      Next program year
  it '-nxtlevel' do
    schoolyear_next_level = schoolyear.program.schoolyears
                                      .find_by programyear: schoolyear.programyear + 1
    expect(schoolyear_next_level).to eq schoolyear.nxtlevel
  end

  it '-program_schoolyears' do
    prog_schoolyears = schoolyear.program.schoolyears

    expect(prog_schoolyears).to eq(schoolyear.program_schoolyears)
  end

  it '-num_program_schoolyears' do
    num_prog_schoolyears = schoolyear.program_schoolyears.count

    expect(num_prog_schoolyears).to eq(schoolyear.num_program_schoolyears)
  end

  it '-program_id_i18n' do
    program_id_i18n_txt = I18n.t('activerecord.attributes.schoolyears.program_id')\
                              .capitalize + ' [ ' + program.id.to_s + ' ]'

    expect(program_id_i18n_txt).to eq schoolyear.program_id_i18n
  end

  it '-name_incoming_cohort_i18n' do
    schoolyear_name_incoming_cohort_i18n = schoolyear.program_name + ' - ' + \
                                           I18n.t('incoming_cohort').capitalize + ' ' + \
                                           schoolyear.yr.to_s
    expect(schoolyear_name_incoming_cohort_i18n).to eq(schoolyear.name_incoming_cohort_i18n)
  end

  it '-school_term' do
    schoolterm = schoolyear.program.schoolterm
    expect(schoolterm).to eq(schoolyear.school_term)
  end

  it '-school_term_name' do
    schoolterm_name = schoolyear.school_term.name
    expect(schoolterm_name).to eq(schoolyear.school_term_name)
  end

  it '-cohort_start' do
    schoolyear_cohort_start = I18n.t('cohort') + ': ' + I18n.t('start') + ' ' + \
                              I18n.l(schoolyear.program.schoolterm.start)
    expect(schoolyear_cohort_start).to eq(schoolyear.cohort_start)
  end

  it '-yr' do
    schoolyear_yr = schoolyear.program.schoolterm.start.year
    expect(schoolyear_yr).to eq(schoolyear.yr)
  end

  it '-term_start_year' do
    year_term_starts = schoolyear.school_term.start.year
    expect(year_term_starts).to eq(schoolyear.term_start_year)
  end

  it '-year_entered_i18n' do
    year_entered_on = I18n.t('entered_on').capitalize + ' ' + schoolyear.term_start_year.to_s
    expect(year_entered_on).to eq(schoolyear.year_entered_i18n)
  end

  it '-incoming_cohort_i18n' do
    incoming_cohort_year = I18n.t('incoming_cohort') + ' ' + schoolyear.term_start_year.to_s
    expect(incoming_cohort_year).to eq(schoolyear.incoming_cohort_i18n)
  end

  it '-program_name_schoolterm' do
    schoolyear_prog_name_term = schoolyear.program_name + ' - ' + I18n.t('start') + ' ' + \
                                schoolyear.program.schoolterm.start.year.to_s
    expect(schoolyear_prog_name_term).to eq(schoolyear.program_name_schoolterm)
  end

  it '-start_year_i18n' do
    schoolyear_start_year_i18n = I18n.t('start') + ' ' + schoolyear.term_start_year.to_s
    expect(schoolyear_start_year_i18n).to eq(schoolyear.start_year_i18n)
  end

  it '-program_name_schoolterm_institution' do
    schoolyear_program_name_schoolterm_institution = schoolyear.program_name\
    + ' - ' + schoolyear.start_year_i18n + ' (' + schoolyear.institution + ')'
    expect(schoolyear_program_name_schoolterm_institution)\
      .to eq(schoolyear.program_name_schoolterm_institution)
  end

  it '-institution' do
    schoolyear_institution = schoolyear.program.institution.name
    expect(schoolyear_institution).to eq(schoolyear.institution)
  end

  it '-name_with_institution' do
    schoolyear_name_with_institution = schoolyear
                                       .program_name + ' (' + schoolyear.institution + ')'
    expect(schoolyear_name_with_institution).to eq schoolyear.name_with_institution
  end

  # Used in registration.rb
  it '-places_available' do
    schoolyear_places_available = schoolyear.program.institution.placesavailable
    expect(schoolyear_places_available).to eq(schoolyear.places_available)
  end

  #   # Refer to program.rb
  it '-program_name_term_institution_short' do
    schoolyear_program_name_term_institution_short = schoolyear
                                                     .program.name_term_institution_short
    expect(schoolyear_program_name_term_institution_short)\
      .to eq schoolyear.program_name_term_institution_short
  end

  it '-program_name_incoming_cohort_program_year' do
    program_area_abbreviation = I18n.t('activerecord.attributes.program.virtual.abbreviation.pap')

    program_info = schoolyear.name_incoming_cohort_i18n

    if schoolyear.level > 1

      program_info += ' - ' + program_area_abbreviation + schoolyear.level.to_s + ' ' \
      + (schoolyear.yr + schoolyear.level - 1).to_s

    end

    expect(program_info).to eq(schoolyear.program_name_incoming_cohort_program_year)
  end

  context 'Class methods' do
    it '#for_schoolterm(schoolterm)' do
      schoolyears_pertaining_to_a_schoolterm = Schoolyear
                                               .joins(:program)
                                               .merge(Program.for_schoolterm(schoolterm))
      expect(schoolyears_pertaining_to_a_schoolterm).to eq(Schoolyear.for_schoolterm(schoolterm))
    end

    it '#for_progyear(programid, year)' do
      schoolyear_pertaining_to_program_and_year = Schoolyear
                                                  .where(program_id: programid, programyear: year)
      expect(schoolyear_pertaining_to_program_and_year).to eq(Schoolyear
        .for_progyear(programid, year))
    end
    # Useful for querying
    it '#self.full' do
      schoolyears_full = Schoolyear.joins(program: :schoolterm).joins(program: :institution)
      expect(schoolyears_full).to eq(Schoolyear.full)
    end

    # e.g. freshman, sophmore
    it '#level(year)' do
      schoolyear_levels = Schoolyear.level(year)
      expect(schoolyear_levels).to eq(Schoolyear.level(year))
    end

    # Alias, for convenience
    it '#on_programyear(year)' do
      expect(Schoolyear.level(year)).to eq(Schoolyear.on_programyear(year))
    end

    it '#freshman' do
      freshman_schoolyears = Schoolyear.where(programyear: 1)
      expect(freshman_schoolyears).to eq(Schoolyear.freshman)
    end

    it '#veteran' do
      veteran_schoolyears = Schoolyear.where.not(id: Schoolyear.freshman)
      expect(veteran_schoolyears).to eq(Schoolyear.veteran)
    end

    # Concluding schoolyear for the various programs
    it '#senior' do
      most_senior_programyear_offered = Schoolyear.pluck(:programyear).max.to_i
      if most_senior_programyear_offered > 1
        senior_schoolyears = Schoolyear.where(programyear: most_senior_programyear_offered)
      end

      expect(senior_schoolyears).to eq(Schoolyear.senior)
    end

    it '#ids_contextual_on(specified_dt)' do
      query = "with Intervals_CTE AS (select s.id, ((s.programyear-1)::VARCHAR || ' year')"\
     '::interval as intervl, s.program_id, s.programyear,t.start, t.finish from schoolyears s, '\
     'programs p, schoolterms t where s.program_id=p.id and p.schoolterm_id=t.id) '\
     ', '\
     'Schoolyear_CTE AS (select i.id, (i.start+i.intervl)::date as start, '\
     "                  (i.start+i.intervl+interval '1 year'-interval '1 day')::date as finish "\
     'from Intervals_CTE i) '\
     'select id from Schoolyear_CTE where start <= ? AND finish >= ? '
      schoolyear_ids_in_context = Schoolyear.find_by_sql [query, specified_dt, specified_dt]

      expect(schoolyear_ids_in_context).to eq(Schoolyear.ids_contextual_on(specified_dt))
    end

    it '#contextual_on(specified_dt)' do
      schoolyears_in_context = Schoolyear.where(id: Schoolyear.ids_contextual_on(specified_dt))

      expect(schoolyears_in_context).to eq(Schoolyear.contextual_on(specified_dt))
    end

    it '#for_schoolterm(schoolterm)' do
      schoolyears_associated_to_schoolterm = Schoolyear
                                             .joins(:program)
                                             .merge(Program.for_schoolterm(schoolterm))
      expect(schoolyears_associated_to_schoolterm).to eq(Schoolyear.for_schoolterm(schoolterm))
    end

    it '#contextual_today' do
      todays_date = Time.zone.today
      schoolyears_contextual_today = Schoolyear.contextual_on(todays_date)
      expect(schoolyears_contextual_today).to eq(Schoolyear.contextual_today)
    end

    it '#not_contextual_today' do
      schoolyears_not_in_todays_context = Schoolyear.where.not(id: Schoolyear.contextual_today)
      expect(schoolyears_not_in_todays_context).to eq(Schoolyear.not_contextual_today)
    end
    #    Alias
    it '#current' do
      expect(Schoolyear.current).to eq(Schoolyear.contextual_today)
    end
    #    Alias, for convenience - not to be confused with present?
    #    Use current above to avoid ambiguity
    it '#present' do
      expect(Schoolyear.present).to eq(Schoolyear.current)
    end

    # Schoolyears (program course offerings) by the specified institution
    it '#from_institution(institution)' do
      schoolyears_from_institution = Schoolyear
                                     .joins(program: :institution)
                                     .where('institutions.id = ? ', institution.id)
      expect(schoolyears_from_institution).to eq(Schoolyear.from_institution(institution))
    end

    # Used in reports rake task
    it '#with_programname(programname)' do
      schoolyear_with_some_program_name = Schoolyear.joins(program: :programname)
                                                    .where('programnames.id = ?', programname.id)
      expect(schoolyear_with_some_program_name).to eq(Schoolyear.with_programname(programname))
    end

    it '#open' do
      schoolyears_open_for_registration = Schoolyear.joins(:program).merge(Program.open)
      expect(schoolyears_open_for_registration).to eq(Schoolyear.open)
    end
  end
end

# ----
# 2018

#
#   # Specs for previously untested code
##
#

#   From early development, not used
#   it '-full?' do
#     schoolyear_is_full = (schoolyear.enrollment == schoolyear.program.)
#     expect(schoolyear_is_full).to eq schoolyear.full?
#   end

#
#
#   # 2018

#   # show view
#   it '- registrations' do
#     schoolyear_registrations = schoolyear.registration
#     expect(schoolyear_registrations).to eq(schoolyear.registration)
#   end
#
#   # show view
#   it '- enrollment' do
#     schoolyear_enrollment = schoolyear.registration.count
#     expect(schoolyear_enrollment).to eq(schoolyear.enrollment)
#   end
#
