# frozen_string_literal: true

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
    safe_join([user.permission.description])
  end

  def pap_staff?(user)
    (pap_local_admin?(user) || pap_manager?(user))
  end

  def medres_staff?(user)
    (medical_residency_local_admin?(user) || medres_manager?(user))
  end

  # user role checking

  def able_to_edit_users?(_user)
    if manager?(current_user) || local_admin?(current_user) || admin?(current_user)

      true

    else false

    end
  end

  def pap_manager?(user)
    if user_signed_in? && (permission_for(user) == 'papmgr')
      true
    else
      false
    end
  end

  def medres_manager?(user)
    if user_signed_in? && (permission_for(user) == 'medresmgr')
      true
    else
      false
    end
  end

  # Checks if user is admin readonly
  def admin_readonly?(user)
    (permission_for(user) == 'adminreadonly')
  end

  def admin_or_readonly?(user)
    if user_signed_in? && (permission_for(user) == 'admin' || permission_for(user) == 'adminreadonly')

      true

    end
  end

  def admin?(user)
    true if user_signed_in? && (permission_for(user) == 'admin')
  end

  def adminreadonly?(user)
    true if user_signed_in? && (permission_for(user) == 'adminreadonly')
  end

  def staff?(user)
    true if local_admin?(user) || manager?(user) || admin_or_readonly?(user)
  end

  def medical_residency_local_admin?(user)
    true if user_signed_in? && (permission_for(user) == 'medreslocaladm')
  end

  def pap_local_admin?(user)
    true if user_signed_in? && (permission_for(user) == 'paplocaladm')
  end

  def pap_collaborator?(user)
    true if user_signed_in? && (permission_for(user) == 'papcollaborator')
  end

  def medres_collaborator?(user)
    true if user_signed_in? && (permission_for(user) == 'medrescollaborator')
  end

  def regular_medres_user?(user)
    if user_signed_in? && (permission_for(user) == 'medrescollaborator' || permission_for(user) == 'medres')

      true

    else

      false

    end
  end

  def regular_pap_user?(user)
    if user_signed_in? && (permission_for(user) == 'papcollaborator' || permission_for(user) == 'pap')

      true

    else

      false

    end
  end

  def regular_user?(user)
    if regular_pap_user?(user) || regular_medres_user?(user)

      true

    else

      false

    end
  end

  def not_regular_user?(user)
    if regular_user?(user)

      false

    else

      true

    end
  end

  def not_collaborator?(_user)
    # Important: this is used in the contact view, when editing *another* user, so it does not check for signed_in

    #   if !(@contact.user.medrescollaborator || @contact.user.papcollaborator)

    if !(permission_for(@contact.user) == 'medrescollaborator' || permission_for(@contact.user) == 'papcollaborator')

      true

    else

      false

    end
  end

  def collaborator?(user)
    true if medres_collaborator?(user) || pap_collaborator?(user)
  end

  def local_admin?(user)
    true if medical_residency_local_admin?(user) || pap_local_admin?(user)
  end

  def logged_in?(_user)
    true if user_signed_in?
  end

  def not_logged_in?(_user)
    true unless user_signed_in?
  end

  def administrator?(user)
    true if admin?(user) || local_admin?(user)
  end

  def manager?(user)
    if medres_manager?(user) || pap_manager?(user)
      true
    else
      false
    end
  end

  # Returns true if user is Admin, Manager or Admin readonly
  def admin_or_manager_or_readonly?(user)
    (admin_or_manager?(user) || admin_readonly?(user))
  end

  def admin_or_manager?(user)
    if manager?(user) || admin_or_readonly?(user)

      true
    else
      false
    end
  end

  def not_admin_or_manager?(user)
    if admin_or_manager?(user)

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

              when permission_for(user) == 'admin' then return Profession.all
              when permission_for(user) == 'papmgr'then return Profession.pap
              when permission_for(user) == 'medresmgr' then return Profession.medres
              when permission_for(user) == 'paplocaladm' then return Profession.pap
              when permission_for(user) == 'medreslocaladm' then return Profession.medres
              when permission_for(user) == 'pap' then return Profession.pap
              when permission_for(user) == 'papcollaborator' then return Profession.pap
              when permission_for(user) == 'medres' then return Profession.medres
              when permission_for(user) == 'medrescollaborator' then return Profession.medres

    end
  end
end
