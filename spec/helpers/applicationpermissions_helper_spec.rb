# frozen_string_literal: true

require 'rails_helper'

describe ApplicationpermissionsHelper, type: :helper do
  include Devise::Test::ControllerHelpers

  let(:permission) { FactoryBot.create(:permission) }
  let(:user) { FactoryBot.create(:user, :pap) }
  #  let(:current_user) { FactoryBot.create(:user, :pap) }

  it '-permission_for(user)' do
    user_permission_kind = user.permission.kind
    expect(user_permission_kind).to eq(helper.permission_for(user))
  end

  it '-profile(user)' do
    user_permission_description = user.permission.description
    safe_txt = safe_join([user_permission_description])
    expect(safe_txt).to eq(helper.profile(user))
  end

  it '-admin_or_readonly?(user)' do
    is_user_admin_or_readonly = helper.user_signed_in? && \
                                (%w[admin adminreadonly].include? helper.permission_for(user))
    expect(is_user_admin_or_readonly).to eq(helper.admin_or_readonly?(user))
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

    it '-pap_local_admin?(user)' do
      is_user_pap_local_admin = (helper.permission_for(user) == 'paplocaladm') && user_signed_in?
      expect(is_user_pap_local_admin).to eq(helper.pap_local_admin?(user))
    end
  end

  context 'medical residency' do
    it '-medres_staff?(user)' do
      is_user_medres_staff = (helper.medres_local_admin?(user) || helper.medres_manager?(user))
      expect(is_user_medres_staff).to eq(helper.medres_staff?(user))
    end

    it '-medres_manager?(user)' do
      is_user_medres_manager = (helper.permission_for(user) == 'medresmgr') && user_signed_in?
      expect(is_user_medres_manager).to eq(helper.medres_manager?(user))
    end

    it '-medres_local_admin?(user)' do
      is_user_medres_local_admin = (helper.permission_for(user) == 'medreslocaladm') && \
                                   user_signed_in?
      expect(is_user_medres_local_admin).to eq(helper.medres_local_admin?(user))
    end
  end

  context 'registrations' do
  end
end
