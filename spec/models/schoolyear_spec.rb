
require 'rails_helper'

RSpec.describe Schoolyear, type: :model do
  let(:biannual_program) { FactoryBot.create(:program, :biannual) }
  let(:program) { FactoryBot.create(:program, :annual) }
  let(:schoolyear) { program.schoolyears.last }

  it 'has a name' do
    #    program = FactoryBot.create(:program, :biannual)

    #    schoolyear = program.schoolyears.last

    puts schoolyear.name
  end

  # Created for 2018 registration season (rake task)

  it '-details' do
    schoolyear_details = schoolyear.ordinalyr + ' '
    schoolyear_details += I18n.t('activerecord.models.schoolyears')
    schoolyear_details += ' [ id : ' + schoolyear.id.to_s + ' ]'
    schoolyear_details
  end

  # rake task
  it '-info' do
    # Schoolyear id: 4, programyear: 2, program_id: 3, pass: 0, theory: 0, practice: 0

    sep=Settings.separator_info


    schoolyear_i18n = I18n.t('activerecord.attributes.schoolyears.id').capitalize
    program_i18n = I18n.t('activerecord.attributes.schoolyears.program_id').capitalize
    prog_year_i18n = I18n.t('activerecord.attributes.schoolyears.programyear')
    theory_i18n = I18n.t('activerecord.attributes.schoolyears.theory')
    practice_i18n = I18n.t('activerecord.attributes.schoolyears.practice')

    schoolyear_info=schoolyear_i18n+' [ '+schoolyear.id.to_s+' ]'

    schoolyear_info+=sep+' '+program_i18n+' [ '+schoolyear.program.id.to_s+' ]'

    schoolyear_info+=sep+' '+prog_year_i18n+' [ '+schoolyear.programyear.to_s+' ]'

    schoolyear_info+=sep+' '+theory_i18n+': '+schoolyear.theory.to_s+' '

    schoolyear_info+=sep+' '+practice_i18n+': '+schoolyear.practice.to_s

    expect(schoolyear_info).to eq(schoolyear.info)
  end

end
