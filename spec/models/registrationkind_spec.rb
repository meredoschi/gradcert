require 'rails_helper'

RSpec.describe Registrationkind, type: :model do
  let(:registrationkind) { FactoryBot.create(:registrationkind) }

  let(:registrationkind_makeup) { FactoryBot.create(:registrationkind, :makeup) }

  let(:registrationkind_repeat) { FactoryBot.create(:registrationkind, :repeat) }

  let(:prefix) { 'activerecord.attributes.registrationkind.' }

  it '-regular can be created' do
    FactoryBot.create(:registrationkind)
  end

  it '-makeup can be created' do
    FactoryBot.create(:registrationkind, :makeup)
  end

  it '-repeat can be created' do
    FactoryBot.create(:registrationkind, :repeat)
  end

  it '-regular_i18n' do
    registrationkind_regular_i18n = I18n.t(prefix + 'regular').downcase

    expect(registrationkind_regular_i18n).to eq(registrationkind.regular_i18n)
  end

  it '-makeup_i18n' do
    registrationkind_makeup_i18n = I18n.t(prefix + 'makeup').downcase

    expect(registrationkind_makeup_i18n).to eq(registrationkind.makeup_i18n)
  end

  it '-repeat_i18n' do
    prefix = 'activerecord.attributes.registrationkind.'
    registrationkind_repeat_i18n = I18n.t(prefix + 'repeat').downcase

    expect(registrationkind_repeat_i18n).to eq(registrationkind.repeat_i18n)
  end

  it '-status (normal)' do
    registrationkind_status = if registrationkind.regular == true then registrationkind\
      .regular_i18n
                              elsif registrationkind.makeup == true then registrationkind\
                                .makeup_i18n
                              elsif registrationkind.repeat == true then registrationkind\
                                .repeat_i18n
                              else I18n.t('activerecord.models.registrationkind') + ': ???'
                              end
    expect(registrationkind_status).to eq registrationkind.status
  end

  it '-student_name' do
    message = 'registration association commented on factory for now, due to spec failure
    on app/models/contact.rb, errors.add(:role_id, :student_may_not_take_staff_role)'
    pending(message)
    registrationkind_student_name = registrationkind.registration.student.contact.name
    expect(registrationkind_student_name).to eq registrationkind.student_name
  end

  it '-school_term_name' do
    message = 'registration association commented on factory for now, due to spec failure
    on app/models/contact.rb, errors.add(:role_id, :student_may_not_take_staff_role)'
    pending(message)
    registrationkind_school_term_name = registrationkind.registration.school_term_name
    expect(registrationkind_school_term_name).to eq registrationkind.school_term_name
  end

  it '-school_year_name' do
    message = 'registration association commented on factory for now, due to spec failure
    on app/models/contact.rb, errors.add(:role_id, :student_may_not_take_staff_role)'
    pending(message)
    registrationkind_school_year_name = registrationkind.registration.schoolyear.name
    expect(registrationkind_school_year_name).to eq registrationkind.school_year_name
  end

  it '-name' do
    message = 'registration association commented on factory for now, due to spec failure
    on app/models/contact.rb, errors.add(:role_id, :student_may_not_take_staff_role)'
    pending(message)
    registrationkind_name = registrationkind.student_name + ', '\
     + I18n.t('activerecord.models.registration') + ' ' + registrationkind.status \
    + ', ' + registrationkind.school_year_name \
    + ' (' + registrationkind.school_term_name + ')'
    expect(registrationkind_name).to eq(registrationkind.name)
  end
end
