module UsersHelper
   def is_own_user(_user)
       if @user == current_user

       true

       else

         false

       end
   end

  def has_contact_name(user)
      if user.contact.name.present?

         true

      else

         false

      end
  end

  def permission_for(user)
 		user.permission.kind
  end

 def profile(user)
       user.permission.description.html_safe
  end

 def show_permission_for(user)
      profile = case

             when permission_for(user) == 'admin' then 'Administrador do sistema (acesso total)'
             when permission_for(user) == 'pap' then "Usu\xC3\xA1rio (Pap)"
             when permission_for(user) == 'papcollaborator' then 'Colaborador Pap (externo) '
             when permission_for(user) == 'paplocaladm' then "Comiss\xC3\xA3o Local (PAP)"
             when permission_for(user) == 'papmgr' then 'Gerente do PAP'
             when permission_for(user) == 'medres' then "Resid\xC3\xAAncia M\xC3\xA9dica"
             when permission_for(user) == 'medrescollaborator' then "Colaborador Resid\xC3\xAAncia M\xC3\xA9dica "
             when permission_for(user) == 'medreslocaladm' then 'COREME'
             when permission_for(user) == 'medresmgr' then "Gerente da Resid\xC3\xAAncia M\xC3\xA9dica"
             when permission_for(user) == 'adminreadonly' then 'Somente leitura - Read-only'
      else 'indefinido'
      end

      profile.html_safe
  end

	def profileflag(user)
 		user.permission.kind.html_safe
  end

 # http://stackoverflow.com/questions/12361631/rendering-partials-from-a-helper-method

   # Revised -------------------------------------------

 # Does not include local admins, which are handled separately using an if in the view
  def institution_with_users_exists_for(user)
      profile = case

             when permission_for(user) == 'admin' && Institution.with_users.count > 0 then return true
             when permission_for(user) == 'adminreadonly' && Institution.with_users_seen_by_readonly.count > 0 then return true
             when permission_for(user) == 'papmgr' && Institution.with_pap_users.count > 0 then return true
             when permission_for(user) == 'medresmgr' && Institution.with_medres_users.count > 0 then return true

      end
  end

def actual_users_permissions_for(user)
		profile = case

   # 		.joins(:user) added to filter permissions actually being used

             when permission_for(user) == 'admin' then return Permission.all.joins(:user)
             when permission_for(user) == 'adminreadonly' then return Permission.readonly.joins(:user)
             when permission_for(user) == 'papmgr' then return Permission.pap.joins(:user)
             when permission_for(user) == 'medresmgr' then return Permission.medres.joins(:user)
             when permission_for(user) == 'medreslocaladm' then return Permission.own_institution(user).medreslocal.joins(:user)
             when permission_for(user) == 'paplocaladm' then return Permission.own_institution(user).paplocal.joins(:user)
      end
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
             when permission_for(user) == 'medreslocaladm' then return Permission.own_institution(user).medreslocal.joins(:user).uniq
             when permission_for(user) == 'paplocaladm' then return Permission.own_institution(user).paplocal.joins(:user).uniq
      end
  end

  def retrieve_institution_with_users_for(user)
      profile = case

             when permission_for(user) == 'admin' then return Institution.with_users.to_a.uniq
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
			profile = case

              when permission_for(user) == 'admin' then render partial: 'form_admin_profile', locals: { f: f }
              when permission_for(user) == 'paplocaladm' then render partial: 'form_paplocaladm_profile', locals: { f: f }
              when permission_for(user) == 'medreslocaladm' then render partial: 'form_medreslocaladm_profile', locals: { f: f }
              when permission_for(user) == 'medresmgr' then render partial: 'form_medres_manager_profile', locals: { f: f }
              when permission_for(user) == 'papmgr' then render partial: 'form_pap_manager_profile', locals: { f: f }
              when permission_for(user) == 'adminreadonly' then #  render partial: "form_profile_readonly", locals: { f: f }

        end
  end
end
