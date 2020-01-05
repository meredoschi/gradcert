# frozen_string_literal: true

# User helper methods
require 'rails_helper'

describe UsersHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user, :pap) }
  let!(:contact) { FactoryBot.create(:contact, :pap_student_role) }

  it '-contact_name?(user)' do
    contact_name_present = (user.contact.present? && user.contact.name.present?)
    expect(contact_name_present).to eq(helper.contact_name?(user))
  end

  context 'defined in application permissions with the same name' do
    # Already defined in application permissions helper (included here for completeness)
    it '-permission_for(user)' do
      user_permission_kind = user.permission.kind
      expect(user_permission_kind).to eq(helper.permission_for(user))
    end

    # Already defined in application permissions helper (included here for completeness)
    it '-profile(user)' do
      user_permission_description = user.permission.description
      safe_txt = safe_join([user_permission_description])
      expect(safe_txt).to eq(helper.profile(user))
    end
  end

  it '-show_permission_for(user)' do
    desc = 'definitions.user_permission.description.'

    permission_description = if permission_for(user) == 'admin'
                               I18n.t(desc + 'admin')
                             elsif permission_for(user) == 'pap'
                               I18n.t(desc + 'pap')
                             elsif permission_for(user) == 'papcollaborator'
                               I18n.t(desc + 'papcollaborator')
                             elsif permission_for(user) == 'paplocaladm'
                               I18n.t(desc + 'paplocaladm')
                             elsif permission_for(user) == 'papmgr'
                               I18n.t(desc + 'papmgr')
                             elsif permission_for(user) == 'medres'
                               I18n.t(desc + 'medres')
                             elsif permission_for(user) == 'medrescollaborator'
                               I18n.t(desc + 'medrescollaborator')
                             elsif permission_for(user) == 'medreslocaladm'
                               I18n.t(desc + 'medreslocaladm')
                             elsif permission_for(user) == 'medresmgr'
                               I18n.t(desc + 'medresmgr')
                             elsif permission_for(user) == 'adminreadonly'
                               I18n.t(desc + 'adminreadonly')
                             else I18n.t('undefined_value')
    end

    expect(safe_join([permission_description])).to eq(helper.show_permission_for(user))
  end

  it '-profileflag(user)' do
    user_profile_flag = safe_join([user.permission.kind])
    expect(user_profile_flag).to eq(helper.profileflag(user))
  end

  # http://stackoverflow.com/questions/12361631/rendering-partials-from-a-helper-method
  #
  # Revised -------------------------------------------
  #
  # Does not include local admins, which are handled separately using an if in the view
  # def institution_with_users_exists_for(user)

  it '-institution_with_users_exists_for(user)' do
    at_least_one_institution_with_users = Institution.with_users.count.positive?
    at_least_one_institution_with_users_viewable_by_read_only_role = \
      Institution.with_users_seen_by_readonly.count.positive?
    at_least_one_institution_with_pap_users = Institution.with_pap_users.count.positive?
    at_least_one_institution_with_medres_users = Institution.with_medres_users.count.positive?

    profile = if permission_for(user) == 'admin' && at_least_one_institution_with_users then true
              elsif permission_for(user) == 'adminreadonly' && \
                    at_least_one_institution_with_users_viewable_by_read_only_role then true
              elsif permission_for(user) == 'papmgr' && \
                    at_least_one_institution_with_pap_users then true
              elsif permission_for(user) == 'medresmgr' && \
                    at_least_one_institution_with_medres_users then true

    end

    expect(profile).to eq(helper.institution_with_users_exists_for(user))
  end

  it '-actual_users_permissions_for(user)' do
    all_permissions = Permission.all.joins(:user)

    relevant_to_read_only = Permission.all.joins(:user)

    # Pap
    relevant_to_pap_local = Permission.own_institution(user).paplocal.joins(:user)
    relevant_to_pap_manager = Permission.pap.joins(:user)

    # Medical residency
    relevant_to_medres_local = Permission.own_institution(user).medres.joins(:user)
    relevant_to_medres_manager = Permission.medres.joins(:user)

    # Future to do: Graduate certificate

    profile = case # rubocop:disable EmptyCaseCondition

              when permission_for(user) == 'admin' then all_permissions
              when permission_for(user) == 'adminreadonly' then relevant_to_read_only
              when permission_for(user) == 'papmgr' then relevant_to_pap_manager
              when permission_for(user) == 'paplocaladm' then relevant_to_pap_local_admin
              when permission_for(user) == 'medresmgr' then relevant_to_medres_manager
              when permission_for(user) == 'medreslocaladm' then relevant_to_medres_local_admin
    end

    expect(profile).to eq(helper.actual_users_permissions_for(user))
  end

    #Includes local admins (i.e. Permissions for users from own institution)
    it '-retrieve_users_permissions_for(user)' do
    profile = case

    when permission_for(user) == 'admin' then return Permission.all
    when permission_for(user) == 'adminreadonly' then return Permission.readonly
    when permission_for(user) == 'papmgr' then return Permission.pap
    when permission_for(user) == 'medresmgr' then return Permission.medres
    when permission_for(user) == 'medreslocaladm' then return Permission.medreslocalrealm
    when permission_for(user) == 'paplocaladm' then return Permission.paplocalrealm

    end
    expect(profile).to eq(helper.retrieve_users_permissions_for(user))

    end

    # Includes local admins (i.e. Permissions for users from own institution)
    # def retrieve_users_permissions_for(user)
    # profile = case
    #
    # when permission_for(user) == 'admin' then return Permission.all
    # when permission_for(user) == 'adminreadonly' then return Permission.readonly
    # when permission_for(user) == 'papmgr' then return Permission.pap
    # when permission_for(user) == 'medresmgr' then return Permission.medres
    # when permission_for(user) == 'medreslocaladm' then return Permission.medreslocalrealm
    # when permission_for(user) == 'paplocaladm' then return Permission.paplocalrealm
    #
    # end
    # end


end

#
#
#
# Includes local admins (i.e. Permissions for users from own institution)
# Only shows permissions from actual users.
# def retrieve_active_users_permissions_for(user)
# profile = case
#
# when permission_for(user) == 'admin' then return Permission.all.joins(:user).uniq
# when permission_for(user) == 'adminreadonly' then return Permission.readonly.joins(:user).uniq
# when permission_for(user) == 'papmgr' then return Permission.pap.joins(:user).uniq
# when permission_for(user) == 'medresmgr' then return Permission.medres.joins(:user).uniq
# when permission_for(user) == 'medreslocaladm' then return Permission.own_institution(user).medreslocal.joins(:user).uniq
# when permission_for(user) == 'paplocaladm' then return Permission.own_institution(user).paplocal.joins(:user).uniq
# end
# end
#
# def retrieve_institution_with_users_for(user)
# profile = case
#
# when permission_for(user) == 'admin' then return Institution.with_users.to_a.uniq
# when permission_for(user) == 'admin' then return Institution.with_users.to_a.uniq
# when permission_for(user) == 'adminreadonly' then return Institution.with_users_seen_by_readonly.to_a.uniq
# when permission_for(user) == 'papmgr' then return Institution.with_pap_users.to_a.uniq
# when permission_for(user) == 'medresmgr' then return Institution.with_medres_users.to_a.uniq
# end
# end
#
# def retrieve_label_institutions_with_users_for(user)
# profile = case
#
# when permission_for(user) == 'admin' then return t('institution_with_users.all')
# when permission_for(user) == 'adminreadonly' then return t('institution_with_users.all')
# when permission_for(user) == 'papmgr'then return t('institution_with_users.pap')
# when permission_for(user) == 'medresmgr' then return t('institution_with_users.medres')
#
# else
#
# return false
# end
# end
# ---------------------------------------------------------------
#
# def permitted_options(user, f)
# profile = case
#
# when permission_for(user) == 'admin' then render partial: 'form_admin_profile', locals: { f: f }
# when permission_for(user) == 'paplocaladm' then render partial: 'form_paplocaladm_profile', locals: { f: f }
# when permission_for(user) == 'medreslocaladm' then render partial: 'form_medreslocaladm_profile', locals: { f: f }
# when permission_for(user) == 'medresmgr' then render partial: 'form_medres_manager_profile', locals: { f: f }
# when permission_for(user) == 'papmgr' then render partial: 'form_pap_manager_profile', locals: { f: f }
# when permission_for(user) == 'adminreadonly' then #  render partial: "form_profile_readonly", locals: { f: f }
#
# end
# end
#
