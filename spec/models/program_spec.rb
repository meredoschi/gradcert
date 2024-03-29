# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Program, type: :model do
  let(:program) { FactoryBot.create(:program, :biannual) }
  let(:admission) { FactoryBot.create(:admission, :zero_amounts) }

  MAX_YEARS = Settings.longest_program_duration.all
  MAX_PROG_COMMENT_LEN = Settings.maximum_comment_length.program
  ABBREVIATION_LENGTH = Settings.shortname_len.program
  INSTITUTION_ABBREVIATION_LENGTH = Settings.shortname_len.institution

  # Possible refinement - To do this according to current user's program (e.g. Pap or Medres)
  # https://stackoverflow.com/questions/23793597/how-to-access-devise-current-user-in-a-rspec-feature-test
  # See config/application_settings.yml
  # N.B. Make sure all>=pap>0, all>=medres>0 (when editing the values) to respect the logic.

  it { is_expected.to validate_length_of(:comment).is_at_most(MAX_PROG_COMMENT_LEN) }

  it { is_expected.to validate_presence_of(:duration) }
  it { is_expected.to validate_presence_of(:institution_id) }
  it { is_expected.to validate_presence_of(:programname_id) }
  it { is_expected.to validate_presence_of(:schoolterm_id) }

  it { is_expected.to validate_numericality_of(:duration).only_integer }
  it { is_expected.to validate_numericality_of(:duration).is_greater_than_or_equal_to(1) }
  it { is_expected.to validate_numericality_of(:duration).is_less_than_or_equal_to(MAX_YEARS) }

  it {
    is_expected.to validate_uniqueness_of(:programname_id)
      .scoped_to(%i[institution_id schoolterm_id]).case_insensitive
  }

  it { is_expected.to accept_nested_attributes_for(:admission) }
  it { is_expected.to accept_nested_attributes_for(:accreditation) }
  it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
  it { is_expected.to accept_nested_attributes_for(:schoolyears).allow_destroy(true) }

  pending 'validate :duration_consistency'
  pending 'validate schoolyear_range'

  it 'annual program can be created (with one schoolyear)' do
    print I18n.t('activerecord.models.schoolyear').capitalize + ': '

    program = FactoryBot.create(:program, :annual)

    puts program.schoolyears.count.to_s
  end

  it 'biannual program can be created (with two schoolyears)' do
    print I18n.t('activerecord.models.schoolyear').capitalize + ': '

    program = FactoryBot.create(:program, :biannual)

    puts program.schoolyears.count.to_s
  end

  it '-is_active?' do
    program_accreditation = program.accreditation # submodel
    situation = program_accreditation.is_original_or_was_renewed?
    expect(program.is_active?).to eq(situation)
  end

  it '-numschoolyears' do
    num_schoolyears = program.schoolyears.count
    expect(program.numschoolyears).to eq(num_schoolyears)
  end

  # Returns a boolean
  it '-internal_address?' do
    situation = (program.internal == true)
    expect(program.internal_address?).to eq(situation)
  end

  # Returns a boolean
  it '-external_address?' do
    expect(program.external_address?).to eq(!program.internal_address?)
  end

  it '-name' do
    #    program = FactoryBot.create(:program, :annual)

    the_program_name = program.name

    expect(program.name).to eq(the_program_name)
  end

  #  expect(program.seasonwithdraws).to eq(season_withdraws)

  it '-registrations' do
    program_registrations = Registration.on_program(program)

    expect(program.registrations).to eq(program_registrations)
  end

  it '-revocations' do
    program_revocations = program.registrations.revoked

    expect(program.revocations).to eq(program_revocations)
  end

  it '-cancellations is a revocation alias' do
    expect(program.cancellations).to eq(program.revocations)
  end

  # Registrations, returns active record relation
  it '-seasonwithdraws' do
    season_withdraws = program.revocations.where('registrations.created_at < ?',
                                                 program.schoolterm.seasonclosure)

    expect(program.seasonwithdraws).to eq(season_withdraws)
  end

  # Returns a number
  it '-numseasonwithdraws' do
    num_season_withdraws = program.seasonwithdraws.count

    expect(program.numseasonwithdraws).to eq(num_season_withdraws)
  end

  # Returns a number
  it '-numregistrations' do
    num_registrations = program.registrations.count

    expect(program.numregistrations).to eq(num_registrations)
  end

  # Returns a boolean
  it '-with_registered_students?' do
    status = program.numregistrations > 0 # boolean

    expect(program.with_registered_students?).to eq(status)
  end

  it '-without_registered_students?' do
    expect(program.without_registered_students?).to eq(!program.with_registered_students?)
  end

  # To become deprecated.  Use name instead

  it '-program_name' do
    program.programname.name
  end

  it '-program_name_schoolterm' do
    program.name + ' (' + program.schoolterm.name + ')'
  end

  it '-shortname' do
    name = program.name

    @abbreviated_name = if name.length > ABBREVIATION_LENGTH # calls name method (already defined)

                          name[0..len] + '...'

                        else

                          name

                        end

    expect(program.shortname).to eq(@abbreviated_name)
  end

  # Alias to
  it '-short (-shortname alias)' do
    expect(program.short).to eq(program.shortname)
  end

  #  it '-workload' do
  #    schoolyears.sum(:theory) + schoolyears.sum(:practice)
  #  end

  it '-theory' do
    program_theory_hours = program.schoolyears.sum(:theory)
    expect(program.theory).to eq(program_theory_hours)
  end

  it '-practice' do
    program_practice_hours = program.schoolyears.sum(:practice)
    expect(program.practice).to eq(program_practice_hours)
  end

  it '-theory' do
    program_theory_hours = program.schoolyears.sum(:theory)
    expect(program.theory).to eq(program_theory_hours)
  end

  it '-workload' do
    program_workload = program.theory + program.practice
    expect(program.workload).to eq(program_workload)
  end

  it '-institution_program_name' do
    institution_name_program_name = program.name + ' (' + program.institution.name + ')'
    expect(program.institution_program_name).to eq(institution_name_program_name)
  end

  # Alias
  it '-program_name_with_institution (alias -institution_program_name)' do
    expect(program.program_name_with_institution).to eq(program.institution_program_name)
  end

  it 'name_term_institution_short' do
    program_name_term_institution_short = program.short + ' | ' + program.schoolterm.name
    program_name_term_institution_short += ' | ' + program.institution.abbrv
    expect(program.name_term_institution_short).to eq(program_name_term_institution_short)
  end

  it 'program_institution_short_name' do
    prog_inst_short_name = program.name.truncate(ABBREVIATION_LENGTH) + ' ('
    prog_inst_short_name += program.institution.name.truncate(INSTITUTION_ABBREVIATION_LENGTH) + ')'
    expect(program.program_institution_short_name).to eq(prog_inst_short_name)
  end

  it '-details_mkdown' do
    sep = Settings.separator_mkdown
    # Program(id: integer, institution_id: integer, programname_id: integer, duration: integer,
    # comment: string, created_at: datetime, updated_at: datetime, pap:
    # boolean, medres: boolean, address_id: integer, internal: boolean,
    # accreditation_id: integer, admission_id: integer, schoolterm_id: integer, professionalspecialt
    # y_id: integer, previouscode: string, parentid: integer)
    prog_details = program.id.to_s + sep + program.programname_id.to_s + sep
    prog_details += program.name + sep + program.institution.id.to_s + sep
    prog_details += program.institution.abbrv + sep + program.schoolterm.id.to_s
    prog_details += sep + I18n.l(program.schoolterm.start)
    expect(prog_details).to eq(program.details_mkdown)
  end

  it ' -info' do
    pending('To do: refactor for clarity, rubocop shows assignment branch condition too high')
    prog_info = ''

    parent_id_i18n = I18n.t('activerecord.attributes.program.virtual.parentid')
    program_i18n = I18n.t('activerecord.models.program').capitalize
    name_i18n = I18n.t('name').capitalize
    schoolterm_i18n = I18n.t('activerecord.models.schoolterm').capitalize
    prog_info += parent_id_i18n + program.parentid.to_s + ' ' if program.parentid.present?

    if program.admission.present? && program.accreditation.present?

      prog_info = program_i18n + ' <' + program.id.to_s + '> ' + program.program_name
      prog_info += ' [' + name_i18n + ' ' + program.programname.id.to_s + '] '

      prog_info += ', ' + I18n.t('activerecord.models.admission').capitalize + ' ['
      prog_info += program.admission.id.to_s + '] ' + ', '
      prog_info += I18n.t('activerecord.models.accreditation').capitalize + ' ['
      prog_info += program.accreditation.id.to_s + '] '

    else

      prog_info += ' [' + program.id.to_s + ']' + program.program_name

    end

    prog_info += ', ' + schoolterm_i18n + ' ' + program.schoolterm.start.year.to_s
    prog_info += ' [' + program.schoolterm.id.to_s + ']'

    expect(prog_info).to eq(program.info)
  end

  # I18n
  it '-area' do
    program_area = ''

    program_area = I18n.t('activerecord.attributes.program.pap') if program.pap?

    program_area = I18n.t('activerecord.attributes.program.medres') if program.medres?

    program_area = I18n.t('activerecord.attributes.program.gradcert') if program.gradcert?

    expect(program_area).to eq(program.area)
  end

  it '-sector' do
    program_sector = ''

    program_sector = 'pap' if program.pap?

    program_sector = 'medres' if program.medres?

    program_sector = 'gradcert' if program.gradcert?

    expect(program_sector).to eq(program.sector)
  end

  it '.latest contains programs from the latest term only' do
    # https://stackoverflow.com/questions/21187824/build-list-of-objects-with-trait
    schoolterms = FactoryBot.create_list(:schoolterm, 4, :pap)

    schoolterms.each do |schoolterm|
      print schoolterm.id.to_s + ' -> '
      print schoolterm.start
    end
  end

  # 2018

  it '-maxenrollment' do
    program_max_enrollment = program.admission.grantsgiven
    expect(program_max_enrollment).to eq(program.maxenrollment)
  end
end
