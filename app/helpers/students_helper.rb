module StudentsHelper

	def registration_history?(s)

			return Registration.for_student(s).exists?

	end

	def possible_students_exist_for(user)

				answer = case

	        when permission_for(user)=='admin' && Contact.may_become_students.count>0 then true
					when permission_for(user)=='papmgr' && Contact.may_become_students.pap.count>0 then true
					when permission_for(user)=='paplocaladm' && Contact.may_become_students.pap.count>0 then true

#				  when permission_for(user)=='paplocaladm' && Supervisor.from_own_institution(current_user).pap.count>0 then return true
#	        when permission_for(user)=='medresmgr' && Supervisor.medres.count>0 then return true
#	        when permission_for(user)=='medreslocaladm' && Supervisor.from_own_institution(current_user).medres.count>0 then return true
#	        when permission_for(user)=='pap' && Assignment.exists_for_supervisor?(current_user) then return true
#					when permission_for(user)=='medres' && Assignment.exists_for_supervisor?(current_user) then return true
#					when permission_for(user)=='papcollaborator' && Assignment.exists_for_supervisor?(current_user) then return true
#					when permission_for(user)=='medrescollaborator' && Assignment.exists_for_supervisor?(current_user) then return true

				else
					return answer
			  end

	end

	def programs_exist_for(user)

				profile = case

	        when permission_for(user)=='admin' && Program.count>0 then return true
				  when permission_for(user)=='papmgr' && Program.pap.count>0 then return true
				  when permission_for(user)=='paplocaladm' && Program.from_own_institution(current_user).pap.count>0 then return true
	        when permission_for(user)=='medresmgr' && Program.medres.count>0 then return true
	        when permission_for(user)=='medreslocaladm' && Program.from_own_institution(current_user).medres.count>0 then return true
				  when permission_for(user)=='pap' && Assignment.exists_for_supervisor?(current_user) then return true
					when permission_for(user)=='medres' && Assignment.exists_for_supervisor?(current_user) then return true
					when permission_for(user)=='papcollaborator' && Assignment.exists_for_supervisor?(current_user) then return true
					when permission_for(user)=='medrescollaborator' && Assignment.exists_for_supervisor?(current_user) then return true
				else
					return false
			  end

	end

  # In each view, there are checks for possible students (i.e. contacts with student profiles)
	def retrieve_possible_students_for(user)

				peoplelist = case

	        when permission_for(user)=='admin' then Contact.may_become_students
  				when permission_for(user)=='papmgr'then Contact.may_become_students.pap
  				when permission_for(user)=='paplocaladm'then Contact.from_own_institution(user).may_become_students.pap
  #        when permission_for(user)=='medresmgr' then return Contact.not_supervisor.with_teaching_role.medres
  #        when permission_for(user)=='paplocaladm' then return Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).pap
  #        when permission_for(user)=='medreslocaladm' then return Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).medres
  #        when permission_for(user)=='pap' then return Contact.not_supervisor.where(user_id: user.id)
  #        when permission_for(user)=='papcollaborator' then return Contact.where(user_id: user.id)
  #        when permission_for(user)=='medres' then return Contact.not_supervisor.where(user_id: user.id)
  #        when permission_for(user)=='medrescollaborator' then return Contact.where(user_id: user.id)
			  end

				return peoplelist

	end

	def retrieve_professions_for(user)

				profile = case

	        when permission_for(user)=='admin' then return Profession.all
					when permission_for(user)=='papmgr'then return Profession.all
#          when permission_for(user)=='papmgr'then return Profession.pap
          when permission_for(user)=='medresmgr' then return Profession.medres
          when permission_for(user)=='paplocaladm' then return Profession.paplocal
          when permission_for(user)=='medreslocaladm' then return Profession.medres
          when permission_for(user)=='pap' then return Profession.pap
          when permission_for(user)=='papcollaborator' then return Profession.pap
          when permission_for(user)=='medres' then return Profession.medres
          when permission_for(user)=='medrescollaborator' then return Profession.medres

			  end
	end


end
