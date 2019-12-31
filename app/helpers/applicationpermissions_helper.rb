# frozen_string_literal: true

# Called on ApplicationController (originally on application helper)
module ApplicationpermissionsHelper
  # <><><><><><><><><>
  # Tested code start
  # <><><><><><><><><>

  def admin_or_adminreadonly?(user)
    user_signed_in? && (%w[admin adminreadonly].include? permission_for(user))
  end

  def permission_for(user)
    user.permission.kind
  end

  def profile(user)
    safe_join([user.permission.description])
  end

  # PAP

  def pap_staff?(user)
    (pap_local_admin?(user) || pap_manager?(user))
  end

  def pap_manager?(user)
    (user_signed_in? && (permission_for(user) == 'papmgr'))
  end

  # Medical residency
  def medres_staff?(user)
    (medical_residency_local_admin?(user) || medres_manager?(user))
  end

  def medres_manager?(user)
    (user_signed_in? && (permission_for(user) == 'medresmgr'))
  end

  def medres_local_admin?(user)
    (permission_for(user) == 'medreslocaladm' && user_signed_in?)
  end

  # user role checking

  def able_to_edit_users?(_user)
    (manager?(current_user) || local_admin?(current_user) || admin?(current_user))
  end

  # Checks if user is admin readonly (e.g. senior management or external auditing agency)
  def admin_readonly?(user)
    (permission_for(user) == 'adminreadonly')
  end

  # <><><><><><><><><>
  # Tested code finish
  # <><><><><><><><><>

  def admin?(user)
    (user_signed_in? && (permission_for(user) == 'admin'))
  end

  def adminreadonly?(user)
    (user_signed_in? && (permission_for(user) == 'adminreadonly'))
  end

  def staff?(user)
    (local_admin?(user) || manager?(user) || admin_or_adminreadonly?(user))
  end

  def medical_residency_local_admin?(user)
    (user_signed_in? && (permission_for(user) == 'medreslocaladm'))
  end

  def pap_local_admin?(user)
    (user_signed_in? && (permission_for(user) == 'paplocaladm'))
  end

  def pap_collaborator?(user)
    (user_signed_in? && (permission_for(user) == 'papcollaborator'))
  end

  def medres_collaborator?(user)
    (user_signed_in? && (permission_for(user) == 'medrescollaborator'))
  end

  def regular_medres_user?(user)
    (user_signed_in? && (permission_for(user) == 'medrescollaborator' || \
       permission_for(user) == 'medres'))
  end

  def regular_pap_user?(user)
    (user_signed_in? && (permission_for(user) == 'papcollaborator' \
     || permission_for(user) == 'pap'))
  end

  def regular_user?(user)
    (regular_pap_user?(user) || regular_medres_user?(user))
  end

  def not_regular_user?(user)
    regular_user?(user)
  end

  # Used in the contact view, when editing *another* user, so it does not check for signed_in
  # e.g. not_collaborator?(@contact.user)
  def not_collaborator?(user)
    !(permission_for(user) == 'medrescollaborator' || permission_for(user) == 'papcollaborator')
  end

  def collaborator?(user)
    (medres_collaborator?(user) || pap_collaborator?(user))
  end

  def local_admin?(user)
    (medical_residency_local_admin?(user) || pap_local_admin?(user))
  end

  def logged_in?(_user)
    user_signed_in?
  end

  def not_logged_in?(_user)
    !user_signed_in?
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
    if manager?(user) || admin_or_adminreadonly?(user)

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

  # Future to do: write tests for the methods below.
  # Possible step before this: review registrations and its associated models.

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
