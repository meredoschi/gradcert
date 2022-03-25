# frozen_string_literal: true

module UsersHelper
  #   deprecated
  #   def is_own_user(_user)
  #       if @user == current_user
  #
  #       true

  #       else

  #         false

  #       end
  #   end

  def contact_name?(user)
    (user.contact.present? && user.contact.name.present?)
  end

  # Defined in in application permissions with the same name
  def permission_for(user)
    user.permission.kind
  end

  # Defined in in application permissions with the same name
  def profile(user)
    safe_join([user.permission.description])
   end

  # rubocop disable: Style/EmptyCaseCondition
  def show_permission_for(user)
    desc = 'definitions.user_permission.description.'

    permission_description = case # rubocop:disable Style/EmptyCaseCondition

                             when permission_for(user) == 'admin'
                               I18n.t(desc + 'admin')
                             when permission_for(user) == 'pap'
                               I18n.t(desc + 'pap')
                             when permission_for(user) == 'papcollaborator'
                               I18n.t(desc + 'papcollaborator')
                             when permission_for(user) == 'paplocaladm'
                               I18n.t(desc + 'paplocaladm')
                             when permission_for(user) == 'papmgr'
                               I18n.t(desc + 'papmgr')
                             when permission_for(user) == 'medres'
                               I18n.t(desc + 'medres')
                             when permission_for(user) == 'medrescollaborator'
                               I18n.t(desc + 'medrescollaborator')
                             when permission_for(user) == 'medreslocaladm'
                               I18n.t(desc + 'medreslocaladm')
                             when permission_for(user) == 'medresmgr'
                               I18n.t(desc + 'medresmgr')
                             when permission_for(user) == 'adminreadonly'
                               I18n.t(desc + 'adminreadonly')
                             else I18n.t('undefined_value')
    end

    safe_join([permission_description])
   end

  def profileflag(user)
    user.permission.kind.html_safe
  end

  # http://stackoverflow.com/questions/12361631/rendering-partials-from-a-helper-method

  # Revised -------------------------------------------

  # Does not include local admins, which are handled separately using an if in the view
  def institution_with_users_exists_for(user)

    at_least_one_institution_with_users = Institution.with_users.count.positive?
    at_least_one_institution_with_users_viewable_by_read_only_role = \
      Institution.with_users_seen_by_readonly.count.positive?
    at_least_one_institution_with_pap_users = Institution.with_pap_users.count.positive?
    at_least_one_institution_with_medres_users = Institution.with_medres_users.count.positive?

    profile = case
              when permission_for(user) == 'admin' && at_least_one_institution_with_users then true
              when permission_for(user) == 'adminreadonly' && \
                   at_least_one_institution_with_users_viewable_by_read_only_role then true
              when permission_for(user) == 'papmgr' && \
                   at_least_one_institution_with_pap_users then true
              when permission_for(user) == 'medresmgr' && \
                   at_least_one_institution_with_medres_users then true

    end

    profile

  end

  # joins(:user) added to display only those permissions actually assigned to existing users
  def actual_users_permissions_for(user)

    all_permissions = Permission.all.joins(:user)

    relevant_to_read_only = Permission.all.joins(:user)

    # Pap
    relevant_to_pap_local_admin = Permission.own_institution(user).paplocal.joins(:user)
    relevant_to_pap_manager = Permission.pap.joins(:user)

    # Medical residency
    relevant_to_medres_local_admin = Permission.own_institution(user).medres.joins(:user)
    relevant_to_medres_manager = Permission.medres.joins(:user)

    # Future to do: Graduate certificate

    profile = case # rubocop:disable Style/EmptyCaseCondition

              when permission_for(user) == 'admin' then all_permissions
              when permission_for(user) == 'adminreadonly' then relevant_to_read_only
              when permission_for(user) == 'papmgr' then relevant_to_pap_manager
              when permission_for(user) == 'paplocaladm' then relevant_to_pap_local_admin
              when permission_for(user) == 'medresmgr' then relevant_to_medres_manager
              when permission_for(user) == 'medreslocaladm' then relevant_to_medres_local_admin
    end

    profile

  end

  # Includes local admins (i.e. Permissions for users from own institution)
  def retrieve_users_permissions_for(user)
    profile = case

              when permission_for(user) == 'admin' then return Permission.all
              when permission_for(user) == 'adminreadonly' then return Permission.readonly
              when permission_for(user) == 'papmgr' then return Permission.pap
              when permission_for(user) == 'medresmgr' then return Permission.medres
              when permission_for(user) == 'medreslocaladm' then return Permission.medreslocalrealm
              when permission_for(user) == 'paplocaladm' then return Permission.paplocalrealm

    end
  end

  # Includes local admins (i.e. Permissions for users from own institution)
  # Only shows permissions from actual users.
  def retrieve_active_users_permissions_for(user)
    profile = case

              when permission_for(user) == 'admin' then return Permission.all.joins(:user).uniq
              when permission_for(user) == 'adminreadonly' then return Permission.readonly.joins(:user).uniq
              when permission_for(user) == 'papmgr' then return Permission.pap.joins(:user).uniq
              when permission_for(user) == 'medresmgr' then return Permission.medres.joins(:user).uniq
              when permission_for(user) == 'medreslocaladm' then return Permission.own_institution(user).medres.joins(:user).uniq
              when permission_for(user) == 'paplocaladm' then return Permission.own_institution(user).paplocal.joins(:user).uniq
    end
  end

  def retrieve_institution_with_users_for(user)
    profile = case

              when permission_for(user) == 'admin' then return Institution.with_users.to_a.uniq
              when permission_for(user) == 'adminreadonly' then return Institution.with_users_seen_by_readonly.to_a.uniq
              when permission_for(user) == 'papmgr' then return Institution.with_pap_users.to_a.uniq
              when permission_for(user) == 'medresmgr' then return Institution.with_medres_users.to_a.uniq
    end
  end

  def retrieve_label_institutions_with_users_for(user)
    profile = case

              when permission_for(user) == 'admin' then return t('institution_with_users.all')
              when permission_for(user) == 'adminreadonly' then return t('institution_with_users.all')
              when permission_for(user) == 'papmgr'then return t('institution_with_users.pap')
              when permission_for(user) == 'medresmgr' then return t('institution_with_users.medres')

              else

                return false
      end
  end
  # ---------------------------------------------------------------

  def permitted_options(user, f)
    profile = if permission_for(user) == 'admin' then render partial: 'form_admin_profile', locals: { f: f }
              elsif permission_for(user) == 'paplocaladm' then render partial: 'form_paplocaladm_profile', locals: { f: f }
              elsif permission_for(user) == 'medreslocaladm' then render partial: 'form_medreslocaladm_profile', locals: { f: f }
              elsif permission_for(user) == 'medresmgr' then render partial: 'form_medres_manager_profile', locals: { f: f }
              elsif permission_for(user) == 'papmgr' then render partial: 'form_pap_manager_profile', locals: { f: f }
              elsif permission_for(user) == 'adminreadonly' #  render partial: "form_profile_readonly", locals: { f: f }

      end
  end
end
