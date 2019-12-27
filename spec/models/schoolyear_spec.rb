# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schoolyear, type: :model do
  let(:biannual_program) { FactoryBot.create(:program, :biannual) }
  let(:program) { FactoryBot.create(:program, :annual) }
  let(:schoolyear) { program.schoolyears.last }


  it 'can be created' do
    print I18n.t('activerecord.models.schoolyear').capitalize + ': '
    schoolyear = FactoryBot.create(:schoolyear, :freshman)
  #  puts schoolyear.info
  end

  # ----
  # 2018

=begin
  it '-identifier_i18n' do
    identifier_i18n_txt = I18n.t('activerecord.attributes.schoolyears.id')\
                              .capitalize + ' [ ' + schoolyear.id.to_s + ' ]'

    expect(identifier_i18n_txt).to eq schoolyear.identifier_i18n
  end

  it '-program_id_i18n' do
    program_id_i18n_txt = I18n.t('activerecord.attributes.schoolyears.program_id')\
                              .capitalize + ' [ ' + program.id.to_s + ' ]'

    expect(program_id_i18n_txt).to eq schoolyear.program_id_i18n
  end

  it '-programyear_id_i18n' do
    programyear_id_i18n_txt = I18n.t('activerecord.attributes.schoolyears.programyear')\
                                  .capitalize + ' [ ' + schoolyear.programyear.to_s + ' ]'

    expect(programyear_id_i18n_txt).to eq schoolyear.programyear_id_i18n
  end

  it '-theory_i18n' do
    theory_i18n_txt = I18n.t('activerecord.attributes.schoolyears.theory')\
                          .capitalize + ': ' + schoolyear.theory.to_s
    expect(theory_i18n_txt).to eq schoolyear.theory_i18n
  end

  it 'workload_i18n' do
    sep = schoolyear.sep

    workload_i18n = schoolyear.theory_i18n + sep + ' ' + schoolyear.practice_i18n

    expect(workload_i18n).to eq schoolyear.workload_i18n
  end

  it '-practice_i18n' do
    practice_i18n_txt = I18n.t('activerecord.attributes.schoolyears.practice')\
                            .capitalize + ': ' + schoolyear.practice.to_s
    expect(practice_i18n_txt).to eq schoolyear.practice_i18n
  end

  it '-info' do
    sep = Settings.separator_info

    schoolyear_info2 = schoolyear.identifier_i18n + sep + ' ' + \
                       schoolyear.program_id_i18n + sep + ' ' + \
                       schoolyear.programyear_id_i18n + sep + ' ' + \
                       schoolyear.workload_i18n

    expect(schoolyear_info2).to eq(schoolyear.info)
  end

  it 'program_schoolyears' do
    prog_schoolyears = schoolyear.program.schoolyears

    expect(prog_schoolyears).to eq(schoolyear.program_schoolyears)
  end

  it 'num_program_schoolyears' do
    num_prog_schoolyears = schoolyear.program_schoolyears.count

    expect(num_prog_schoolyears).to eq(schoolyear.num_program_schoolyears)
  end

  it '-sep' do
    sep = Settings.separator_info

    expect(sep).to eq schoolyear.sep
  end

  # Created for 2018 registration season (rake task)

  it '-details' do
    schoolyear_details = schoolyear.ordinalyr + ' '
    schoolyear_details += I18n.t('activerecord.models.schoolyears')
    schoolyear_details += ' [ id : ' + schoolyear.id.to_s + ' ]'
    schoolyear_details
  end

  # Specs for previously untested code

  it '-name' do
    schoolyear_name = schoolyear.program_name
    expect(schoolyear_name).to eq(schoolyear.name)
  end

  it '-program_name' do
    schoolyear_program_name = schoolyear.programyear.to_s\
     + schoolyear.ordinal_suffix + ' ' + schoolyear.program.program_name

    expect(schoolyear_program_name).to eq(schoolyear.program_name)
  end

  it '-ordinal_suffix' do
    schoolyear_ordinal_suffix = ''
    schoolyear_ordinal_suffix = +'º' if I18n.default_locale.to_s[0..2] == 'pt_'

    expect(schoolyear_ordinal_suffix).to eq(schoolyear.ordinal_suffix)
  end

  it '-ordinal_year_i18n' do
    schoolyear_ordinal_year_i18n = schoolyear.ordinalyr + ' ' + I18n.t('year')
    expect(schoolyear_ordinal_year_i18n).to eq(schoolyear.ordinal_year_i18n)
  end

  # Program year ordinal
  it '- ordinalyr' do
    schoolyear_ordinal_year = schoolyear.programyear.to_s + schoolyear.ordinal_suffix
    expect(schoolyear_ordinal_year).to eq(schoolyear.ordinalyr)
  end

  it '- cohort_start' do
    schoolyear_cohort_start = I18n.t('cohort') + ': ' + I18n.t('start')\
     + ' ' + I18n.l(schoolyear.program.schoolterm.start)
    expect(schoolyear_cohort_start).to eq(schoolyear.cohort_start)
  end

  it '- school_term' do
    schoolyear_program_schoolterm = schoolyear.school_term
    expect(schoolyear_program_schoolterm).to eq(schoolyear.school_term)
  end

  it '- school_term_name' do
    schoolyear_program_schoolterm_name = schoolyear.school_term.name
    expect(schoolyear_program_schoolterm_name).to eq(schoolyear.school_term_name)
  end

  it '-full?' do
    schoolyear_is_full = (schoolyear.enrollment == schoolyear.program.maxenrollment)
    expect(schoolyear_is_full).to eq schoolyear.full?
  end

  it '-first_year?' do
    schoolyear_is_first = (schoolyear.programyear == 1)
    expect(schoolyear_is_first).to eq schoolyear.first_year?
  end

  # 2018

  it '-term_start_year' do
    schoolyear_term_start_year = schoolyear.school_term.start.year
    expect(schoolyear_term_start_year).to eq schoolyear.term_start_year
  end

  it '-year_entered_i18n' do
    schoolyear_year_entered_i18n = I18n.t('entered_on').capitalize + ' '\
     + schoolyear.term_start_year.to_s
    expect(schoolyear_year_entered_i18n).to eq schoolyear.year_entered_i18n
  end

  it '-incoming_cohort_i18n' do
    schoolyear_incoming_cohort_i18n = I18n.t('incoming_cohort') + \
                                      ' ' + schoolyear.term_start_year.to_s
    expect(schoolyear_incoming_cohort_i18n).to eq schoolyear.incoming_cohort_i18n
  end

  it '-program_name_schoolterm' do
    schoolyear_program_name_schoolterm = schoolyear.program_name + ' - ' \
    + I18n.t('start') + ' ' + schoolyear.program.schoolterm.start.year.to_s
    expect(schoolyear_program_name_schoolterm).to eq schoolyear.program_name_schoolterm
  end

  it '-yr' do
    schoolyear_yr = schoolyear.program.schoolterm.start.year
    expect(schoolyear_yr).to eq schoolyear.yr
  end

  it '-name_incoming_cohort_i18n' do
    schoolyear_name_incoming_cohort_i18n = schoolyear.program_name + ' - '\
     + I18n.t('incoming_cohort').capitalize + ' ' + schoolyear.yr.to_s
    expect(schoolyear_name_incoming_cohort_i18n).to eq schoolyear.name_incoming_cohort_i18n
  end

  # ---

  it '-start_year_i18n' do
    schoolyear_start_year_i18n = I18n.t('start')\
     + ' ' + schoolyear.program.schoolterm.start.year.to_s
    expect(schoolyear_start_year_i18n).to eq(schoolyear_start_year_i18n)
  end

  # Hotfix
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
    schoolyear_name_with_institution = schoolyear.program_name + ' (' + schoolyear.institution + ')'
    expect(schoolyear_name_with_institution).to eq schoolyear.name_with_institution
  end

  # Refer to program.rb
  it '-program_name_term_institution_short' do
    schoolyear_program_name_term_institution_short = schoolyear.program.name_term_institution_short
    expect(schoolyear_program_name_term_institution_short)\
      .to eq schoolyear.program_name_term_institution_short
  end

  it '-workload' do
    schoolyear_workload = schoolyear.theory
    expect(schoolyear_workload).to eq(schoolyear.workload)
  end

  # show view
  it '- registrations' do
    schoolyear_registrations = schoolyear.registration
    expect(schoolyear_registrations).to eq(schoolyear.registration)
  end

  # show view
  it '- enrollment' do
    schoolyear_enrollment = schoolyear.registration.count
    expect(schoolyear_enrollment).to eq(schoolyear.enrollment)
  end

  # shorthand for programyear number (1 first, 2 second, 3 third and so forth)
  it '-level' do
    schoolyear_level = schoolyear.programyear

    expect(schoolyear_level).to eq schoolyear.level
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

  # Next program year
  it '-nextlevel' do
    schoolyear_next_level = schoolyear.program.schoolyears\
                                      .where(programyear: schoolyear.programyear + 1).first

    expect(schoolyear_next_level).to eq schoolyear.nextlevel
  end

  it '-program_name_incoming_cohort_program_year' do
    schoolyear_program_name_incoming_cohort_program_year = schoolyear.name_incoming_cohort_i18n

    if schoolyear.level > 1

      schoolyear_program_name_incoming_cohort_program_year += ' -  '\
       + schoolyear.sector_i18n + schoolyear.level.to_s\
       + ' ' + (schoolyear.yr + schoolyear.level - 1).to_s

    end

    expect(schoolyear_program_name_incoming_cohort_program_year)\
      .to eq(schoolyear.program_name_incoming_cohort_program_year)
  end

=end

end
