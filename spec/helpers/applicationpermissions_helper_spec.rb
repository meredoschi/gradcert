# frozen_string_literal: true

require 'rails_helper'

describe ApplicationpermissionsHelper, type: :helper do
  include Devise::Test::ControllerHelpers

  let(:permission) { FactoryBot.create(:permission) }
  let(:user) { FactoryBot.create(:user, :pap) }
  let(:current_user) { FactoryBot.create(:user, :pap) }

  it '-permission_for(user)' do
    user_permission_kind = user.permission.kind
    expect(user_permission_kind).to eq(helper.permission_for(user))
  end

  it '-profile(user)' do
    user_permission_description = user.permission.description
    safe_txt = safe_join([user_permission_description])
    expect(safe_txt).to eq(helper.profile(user))
  end

  context 'pap' do
    it '-pap_staff?(user)' do
      is_user_pap_staff = (helper.pap_local_admin?(user) || helper.pap_manager?(user))
      expect(is_user_pap_staff).to eq(helper.pap_staff?(user))
    end

    it '-pap_manager?(user)' do
      is_user_pap_manager = (helper.permission_for(user) == 'papmgr') && user_signed_in?
      expect(is_user_pap_manager).to eq(helper.pap_manager?(user))
    end
  end

  context 'registrations' do
  end
end
