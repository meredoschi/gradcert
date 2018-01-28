# Called on ApplicationController (originally on application helper)
module ApplicationpermissionsHelper

  # Fetch students
  def registrations_for(user)
    records = if permission_for(user) == 'admin' then Registration.all
              elsif permission_for(user) == 'papmgr' then Registration.pap
              elsif permission_for(user) == 'paplocaladm'
                Registration.pap.from_own_institution(user)
              end

    records
  end

  def registration_details(user)
    profile = if permission_for(user) == 'admin' then :student_name_schoolyear_institution_abbrv

              elsif permission_for(user) == 'papmgr' then :student_name_schoolyear_institution_abbrv
              elsif permission_for(user) == 'paplocaladm' then :student_name_id_schoolyear_term
              else 'indefinido'
              end

    profile
  end

  def permission_for(user)
    user.permission.kind
  end

  def profile(user)
    user.permission.description.html_safe
  end

  def is_pap_staff(user)
    (is_pap_local_admin(user) || is_pap_manager(user))
  end

  def is_medres_staff(user)
    (is_medical_residency_local_admin(user) || is_medres_manager(user))
  end

  # user role checking

  def is_able_to_edit_users(_user)
    if is_manager(current_user) || is_local_admin(current_user) || is_admin(current_user)

      true

    else false

    end
  end

  def is_pap_manager(user)
    if user_signed_in? && (permission_for(user) == 'papmgr')
      true
    else
      false
    end
  end

  def is_medres_manager(user)
    if user_signed_in? && (permission_for(user) == 'medresmgr')
      true
    else
      false
    end
  end

  # Checks if user is admin readonly
  def is_admin_readonly(user)
    (permission_for(user) == 'adminreadonly')
  end

  def is_admin_or_readonly(user)
    if user_signed_in? && (permission_for(user) == 'admin' || permission_for(user) == 'adminreadonly')

      true

    end
  end

  def is_admin(user)
    true if user_signed_in? && (permission_for(user) == 'admin')
  end

  def is_adminreadonly(user)
    true if user_signed_in? && (permission_for(user) == 'adminreadonly')
  end

  def is_staff(user)
    if is_local_admin(user) || is_manager(user) || is_admin_or_readonly(user)

      true

    end
  end

  def is_medical_residency_local_admin(user)
    true if user_signed_in? && (permission_for(user) == 'medreslocaladm')
  end

  def is_pap_local_admin(user)
    true if user_signed_in? && (permission_for(user) == 'paplocaladm')
  end

  def is_pap_collaborator(user)
    true if user_signed_in? && (permission_for(user) == 'papcollaborator')
  end

  def is_medres_collaborator(user)
    true if user_signed_in? && (permission_for(user) == 'medrescollaborator')
  end

  def is_regular_medres_user(user)
    if user_signed_in? && (permission_for(user) == 'medrescollaborator' || permission_for(user) == 'medres')

      true

    else

      false

    end
  end

  def is_regular_pap_user(user)
    if user_signed_in? && (permission_for(user) == 'papcollaborator' || permission_for(user) == 'pap')

      true

    else

      false

    end
  end

  def is_regular_user(user)
    if is_regular_pap_user(user) || is_regular_medres_user(user)

      true

    else

      false

    end
  end

  def is_not_regular_user(user)
    if is_regular_user(user)

      false

    else

      true

    end
  end

  def is_not_collaborator(_user)
    # Important: this is used in the contact view, when editing *another* user, so it does not check for signed_in

    # 	if !(@contact.user.medrescollaborator || @contact.user.papcollaborator)

    if	!(permission_for(@contact.user) == 'medrescollaborator' || permission_for(@contact.user) == 'papcollaborator')

      true

    else

      false

    end
  end

  def is_collaborator(user)
    true if is_medres_collaborator(user) || is_pap_collaborator(user)
  end

  def is_local_admin(user)
    true if is_medical_residency_local_admin(user) || is_pap_local_admin(user)
  end

  def is_logged_in(_user)
    true if user_signed_in?
  end

  def is_not_logged_in(_user)
    true unless user_signed_in?
  end

  def is_administrator(user)
    true if is_admin(user) || is_local_admin(user)
  end

  def is_manager(user)
    if is_medres_manager(user) || is_pap_manager(user)
      true
    else
      false
    end
  end

  # Returns true if user is Admin, Manager or Admin readonly
  def is_admin_or_manager_or_readonly(user)
    (is_admin_or_manager(user) || is_admin_readonly(user))
  end

  def is_admin_or_manager(user)
    if is_manager(user) || is_admin_or_readonly(user)

      true
    else
      false
    end
  end

  def is_not_admin_or_manager(user)
    if is_admin_or_manager(user)

      false

    else

      true

    end
  end

  # Welcome screen
  def belongs_to_pap(user)
    user.permission.kind.in?(%w[pap papcollaborator paplocaladm papmgr])
  end

  def belongs_to_medres(user)
    user.permission.kind.in?(%w[medres medrescollaborator medreslocaladm medresmgr])
  end

  # Retrieve the sorted list of professions for the role
  # Used for supervisors, students

  def retrieve_professions_for(user)

        profile = case

          when permission_for(user)=='admin' then return Profession.all
          when permission_for(user)=='papmgr'then return Profession.pap
          when permission_for(user)=='medresmgr' then return Profession.medres
          when permission_for(user)=='paplocaladm' then return Profession.pap
          when permission_for(user)=='medreslocaladm' then return Profession.medres
          when permission_for(user)=='pap' then return Profession.pap
          when permission_for(user)=='papcollaborator' then return Profession.pap
          when permission_for(user)=='medres' then return Profession.medres
          when permission_for(user)=='medrescollaborator' then return Profession.medres

        end
  end

end
