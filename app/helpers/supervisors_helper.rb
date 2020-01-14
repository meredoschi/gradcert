# frozen_string_literal: true

module SupervisorsHelper
  def is_own_supervisor(_user)
    @supervisor.contact.user == current_user
  end

  def teachers_exist_for(user)
    profile = case

              when permission_for(user) == 'admin' && Contact.not_supervisor.with_teaching_role.count > 0 then return true
              when permission_for(user) == 'papmgr' && Contact.not_supervisor.with_teaching_role.pap.count > 0 then return true
              when permission_for(user) == 'paplocaladm' && Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).pap.count > 0 then return true
              when permission_for(user) == 'medresmgr' && Contact.not_supervisor.with_teaching_role.medres.count > 0 then return true
              when permission_for(user) == 'medreslocaladm' && Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).medres.count > 0 then return true
              else
                return false
    end
  end

  # In each view, there are checks for teachers (i.e. contacts with teaching profiles)
  def retrieve_teachers_for(user)
    profile = case

              when permission_for(user) == 'admin' then return Contact.not_supervisor.with_teaching_role
              when permission_for(user) == 'papmgr'then return Contact.not_supervisor.with_teaching_role.pap
              when permission_for(user) == 'medresmgr' then return Contact.not_supervisor.with_teaching_role.medres
              when permission_for(user) == 'paplocaladm' then return Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).pap
              when permission_for(user) == 'medreslocaladm' then return Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).medres
              when permission_for(user) == 'pap' then return Contact.not_supervisor.where(user_id: user.id)
              when permission_for(user) == 'papcollaborator' then return Contact.where(user_id: user.id)
              when permission_for(user) == 'medres' then return Contact.not_supervisor.where(user_id: user.id)
              when permission_for(user) == 'medrescollaborator' then return Contact.where(user_id: user.id)
    end
  end

  # Retrieve the sorted list of professions for the role
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

  def index_header(user)
    profile = if permission_for(user) == 'admin' && Contact.with_teaching_role.count > 0 then render partial: 'index_header'
              elsif permission_for(user) == 'adminreadonly' && Contact.with_teaching_role.count > 0 then render partial: 'index_header'

              elsif permission_for(user) == 'papmgr' && Contact.with_teaching_role.pap.count > 0 then render partial: 'index_header'
              elsif permission_for(user) == 'paplocaladm' && Contact.with_teaching_role.from_own_institution(current_user).pap.count > 0 then render partial: 'index_header'
              elsif permission_for(user) == 'medresmgr' && Contact.with_teaching_role.medres.count > 0 then render partial: 'index_header'
              elsif permission_for(user) == 'medreslocaladm' && Contact.with_teaching_role.from_own_institution(current_user).medres.count > 0 then render partial: 'index_header'
              elsif permission_for(user) == 'pap' && Supervisor.registered?(current_user) then render partial: 'index_header'
              elsif permission_for(user) == 'medres' && Supervisor.registered?(current_user) then render partial: 'index_header'
              elsif permission_for(user) == 'medrescollaborator' && Supervisor.registered?(current_user) then render partial: 'index_header'
              elsif permission_for(user) == 'papcollaborator' && Supervisor.registered?(current_user) then render partial: 'index_header'
              else
                render partial: 'error_no_teachers.html.erb'
    end
  end
end
