# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :feature do
  def sign_in_as_program_manager
    visit '/users/sign_in'
    fill_in 'user_email', with: prog_manager_email
    fill_in 'user_password', with: sample_password
    click_button access_i18n
  end

  let(:prog_manager_email) { 'program-manager@example.com' }
  let(:sample_password) { 'samplepass' }
  let(:access_i18n) { I18n.t('devise-custom.access') }
  let(:users_i18n) { I18n.t('activerecord.models.user').pluralize }

  it 'Users index displays the pluralized model name (i18n)' do
    sign_in_as_program_manager

    visit '/users'
    expect(page).to have_content users_i18n
  end
end
