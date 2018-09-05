# frozen_string_literal: true

require 'rails_helper'

describe 'User sign in', type: :feature do
  let(:sys_admin_email) { 'system-admin@example.com' }
  let(:prog_manager_email) { 'program-manager@example.com' }
  let(:inst_staff_email) { 'dean@state-u.org' }

  let(:sample_password) { 'samplepass' }

  let(:access_i18n) { I18n.t('devise-custom.access') }

  it 'System administrator' do
    visit '/users/sign_in'
    fill_in 'user_email', with: sys_admin_email
    fill_in 'user_password', with: sample_password
    click_button access_i18n
    expect(page).to have_content sys_admin_email
  end

  it 'Program manager' do
    visit '/users/sign_in'
    fill_in 'user_email', with: prog_manager_email
    fill_in 'user_password', with: sample_password
    click_button access_i18n
    expect(page).to have_content prog_manager_email
  end

  it 'Local manager (institution staff)' do
    visit '/users/sign_in'
    fill_in 'user_email', with: inst_staff_email
    fill_in 'user_password', with: sample_password
    click_button access_i18n
    expect(page).to have_content inst_staff_email
  end
end
