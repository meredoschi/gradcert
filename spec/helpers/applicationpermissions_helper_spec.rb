# frozen_string_literal: true

require 'rails_helper'

describe ApplicationpermissionsHelper, type: :helper do
  include Devise::Test::ControllerHelpers

  let(:permission) { FactoryBot.create(:permission) }
  let(:user) { FactoryBot.create(:user, :pap) }
  let(:current_user) { :user }
  
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

  it '-admin_or_adminreadonly?(user)' do
    is_user_admin_or_readonly = helper.user_signed_in? && \
                                (%w[admin adminreadonly].include? helper.permission_for(user))
    expect(is_user_admin_or_readonly).to eq(helper.admin_or_adminreadonly?(user))
  end

  it '-able_to_edit_users?(user)' do
    is_able_to_edit_users = (helper.manager?(user) || helper.local_admin?(user) || \
    helper.admin?(user))
    expect(is_able_to_edit_users).to eq(helper.able_to_edit_users?(user))
  end

  it '-admin?(user)' do
    is_admin = (helper.user_signed_in? && (helper.permission_for(user) == 'admin'))
    expect(is_admin).to eq(helper.admin?(user))
  end

  it '-adminreadonly?(user)' do
    is_admin_read_only = (helper.user_signed_in? \
       && (helper.permission_for(user) == 'adminreadonly'))
    expect(is_admin_read_only).to eq(helper.admin?(user))
  end

  it '-staff?(user)' do
    is_staff = (helper.local_admin?(user) || helper.manager?(user) \
    || helper.admin_or_adminreadonly?(user))
    expect(is_staff).to eq(helper.staff?(user))
  end

  # Checks if user is admin readonly (e.g. senior management or external auditing agency)
  it '-admin_readonly?(user)' do
    is_user_read_only_admin = (helper.permission_for(user) == 'adminreadonly')
    expect(is_user_read_only_admin).to eq(helper.admin_readonly?(user))
  end

  it '-regular_user?(user)' do
    is_regular_user = (helper.regular_pap_user?(user) || helper.regular_medres_user?(user))
    expect(is_regular_user).to eq(helper.regular_user?(user))
  end

  it '-not_regular_user?(user)' do
    is_not_regular_user = !helper.regular_user?(user)
    expect(is_not_regular_user).to eq(helper.not_regular_user?(user))
  end

  it '-collaborator?(user)' do
    is_collaborator = (helper.pap_collaborator?(user) || helper.medres_collaborator?(user))
    expect(is_collaborator).to eq(helper.collaborator?(user))
  end

  it '-not_collaborator?(user)' do
    is_not_collaborator = !helper.collaborator?(user)
    expect(is_not_collaborator).to eq(helper.not_collaborator?(user))
  end

  it '-local_admin?(user)' do
    is_local_admin = (helper.pap_local_admin?(user) || helper.medres_local_admin?(user))
    expect(is_local_admin).to eq(helper.local_admin?(user))
  end

  it '-admin_or_manager_or_adminreadonly?(user)' do
    is_admin_or_manager_or_adminreadonly = (helper.manager?(user) \
    || helper.admin_or_adminreadonly?(user))
    expect(is_admin_or_manager_or_adminreadonly)
      .to eq(helper.admin_or_manager_or_adminreadonly?(user))
  end

  it '-not_admin_or_manager?(user)' do
    is_not_admin_or_manager = !helper.admin_or_manager?(user)
    expect(is_not_admin_or_manager).to eq(helper.not_admin_or_manager?(user))
  end

  it '-logged_in?(user)' do
    is_logged_in = helper.user_signed_in?
    expect(is_logged_in).to eq(helper.logged_in?(user))
  end

  it '-not_logged_in?(user)' do
    is_not_logged_in = !helper.user_signed_in?
    expect(is_not_logged_in).to eq(helper.not_logged_in?(user))
  end

  it '-manager?(user)' do
    is_manager = (helper.pap_manager?(user) || helper.medres_manager?(user))
    expect(is_manager).to eq(helper.manager?(user))
  end

  # Retrieve the sorted list of professions for the role
  # Used for supervisors, students
  it '-retrieve_professions_for(user)' do
    professions_list = if permission_for(user) == 'admin' then Profession.all
                       elsif belongs_to_pap?(user) then Profession.pap
                       elsif belongs_to_medres?(user) then Profession.medres
                       end
    expect(professions_list).to eq(helper.retrieve_professions_for(user))
  end

  context 'pap' do
    # Welcome screen
    it '-belongs_to_pap?(user)' do
      does_user_belong_to_pap = user.permission.kind.in?(%w[pap papcollaborator paplocaladm papmgr])
      expect(does_user_belong_to_pap).to eq(helper.belongs_to_pap?(user))
    end

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

    it '-pap_collaborator?(user)' do
      is_user_pap_collaborator = (helper.permission_for(user) == 'papcollaborator') \
      && user_signed_in?
      expect(is_user_pap_collaborator).to eq(helper.pap_collaborator?(user))
    end

    it '-regular_pap_user?(user)' do
      is_regular_pap_user = (helper.user_signed_in? && (permission_for(user) == 'papcollaborator' \
       || permission_for(user) == 'pap'))
      expect(is_regular_pap_user).to eq(helper.regular_pap_user?(user))
    end
  end

  context 'medical residency' do
    # Welcome screen
    it '-belongs_to_medres?(user)' do
      does_user_belong_to_medres = user.permission.kind
                                       .in?(%w[medres medrescollaborator medreslocaladm medresmgr])
      expect(does_user_belong_to_medres).to eq(helper.belongs_to_medres?(user))
    end

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

    it '-medres_collaborator?(user)' do
      is_user_medres_collaborator = (helper.permission_for(user) == 'medrescollaborator') \
       && user_signed_in?
      expect(is_user_medres_collaborator).to eq(helper.medres_collaborator?(user))
    end

    it '-regular_medres_user?(user)' do
      is_regular_medres_user = (helper.user_signed_in? \
        && (permission_for(user) == 'medrescollaborator' || permission_for(user) == 'medres'))
      expect(is_regular_medres_user).to eq(helper.regular_medres_user?(user))
    end
  end

  context 'registrations' do
  end
end
