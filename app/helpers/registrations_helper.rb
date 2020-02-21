module RegistrationsHelper

	# Takes in annotation.payroll, called from show view
	def actual_absences_during_payroll(p)

		return @actual_absence_events.for_payroll(p).absences_total

	end
	# Already processed on a previous payroll
	def already_cancelled?(registration)

	    if registration.accreditation.present?
			  return registration.accreditation.cancellation_processed?
			else
			  return false
			end
	end

	# Is the registration season open? 	See schoolterm
	def in_season?

		Schoolterm.latest.registrationseason
	#	return @registration.present? && @registration.school_term.open?
  # 	  return true

	end

	# Used in form view partial
	def display_details

		if admin_or_manager?(current_user)

			txt=@registration.schoolyear_with_institution_and_term

  	else

  		txt=@registration.schoolyear_name

  	end

  	return txt.html_safe


	end


	def registered_students_for_program(p)

			return Registration.on_program(p)

	end

	def display_registration_status(accr)

				status = case

	        when accr.original? then return ta('registration.accreditation.original').html_safe
	        when accr.was_renewed? then return ta('registration.accreditation.renewed').html_safe
	        when accr.was_suspended? then return ta('registration.accreditation.suspended').html_safe
	       	when accr.was_revoked? then return ta('registration.accreditation.revoked').html_safe

			  end

	end

	# Test if registration is makeup or repeat
	def is_makeup_or_repeat?(registration)

		return (registration.makeup?) || (registration.repeat?)

	end

	# Makeup or repeats
	def special_registrations_exist?

		return @num_special_registrations>0

	end

	# Makeups
	def makeup_registrations_exist?

		return @num_makeup_registrations>0

	end

	# Repeats
	def repeat_registrations_exist?

		return @num_repeat_registrations>0

	end

  # display registration kind (mutually exclusive booleans)
	def display_kind(registration)

			rk=registration.registrationkind

			# Hotfix, allowed for nil.  To do: fix on the controller when creating objects
			if rk then

				status = case

				#	when rk.regular? then return ta('registrationkind.regular').html_safe
				  when rk.regular? then return ta('registrationkind.regular').html_safe
#					when rk.regular? then return ' '.html_safe

	        when rk.makeup? then return  ta('registrationkind.makeup').html_safe
					when rk.repeat? then return  ta('registrationkind.repeat').html_safe

			  end

			else

				return ta('registrationkind.regular').html_safe

			end
	end

	def display_annotation_absences(registration)

		num_absences=Annotation.for_registration(registration).pluck(:absences).sum

		if num_absences>0

				return num_absences

		end

	end

	def display_actual_absences(registration)

			return Event.with_actual_absences_for(registration).absences_total

	end

	def warn_if_no_programs

		txt=''

		if !current_user.institution.with_programs?

				txt+=t('errors.registrations.no_programs_found')
		end

		return txt.html_safe

	end

	def warn_if_no_programs

		txt=''

		if !current_user.institution.with_programs?

				txt+=t('errors.registrations.no_programs_found')
		end

		return txt.html_safe

	end

	# Used in new action
	def incoming_students_not_registered_yet(user)

				peoplelist = case

				when permission_for(user)=='admin' then Student.not_barred.not_registered
				when permission_for(user)=='papmgr' then Student.not_barred.pap.not_registered
				when permission_for(user)=='paplocaladm' then Student.not_barred.pap.from_own_institution(current_user).not_registered

		  end

			  return peoplelist
	end

	def num_incoming_students(user)

				peoplelist = case

				when permission_for(user)=='admin' then Student.not_barred.not_registered.count
				when permission_for(user)=='papmgr' then Student.not_barred.pap.not_registered.count
				when permission_for(user)=='paplocaladm' then Student.not_barred.pap.from_own_institution(current_user).not_registered.count

			end

				return peoplelist
	end


  # Fetch students
	def incoming_students(user)

				peoplelist = case

	        when permission_for(user)=='admin' then Student.incoming
	        when permission_for(user)=='papmgr' then Student.pap.incoming
#	        when permission_for(user)=='paplocaladm' then Student.not_registered.from_own_institution(current_user)
#	        when permission_for(user)=='paplocaladm' then Student.incoming.from_own_institution(current_user)
          when permission_for(user)=='paplocaladm' then Student.from_own_institution(current_user).incoming


# 	        when permission_for(user)=='paplocaladm' then Student.from_own_institution_but_not_registered_yet(user)

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


  # Fetch schoolyears
	def retrieve_schoolyears_for(user)

				schoolyearlist = case

				when admin?(user) then Schoolyear.contextual_today.ordered_by_programname_and_year
	        when pap_manager?(user) then Schoolyear.contextual_today.ordered_by_programname_and_year
			when pap_local_admin?(user) then Schoolyear.freshman.open.for_users_institution(user).ordered_by_programname_and_year
#  				when pap_local_admin?(user) then @all_schoolyears.open.for_users_institution(user).freshman

  #        when permission_for(user)=='medreslocaladm' then return Contact.not_supervisor.with_teaching_role.from_own_institution(current_user).medres
  #        when permission_for(user)=='pap' then return Contact.not_supervisor.where(user_id: user.id)
  #        when permission_for(user)=='papcollaborator' then return Contact.where(user_id: user.id)
  #        when permission_for(user)=='medres' then return Contact.not_supervisor.where(user_id: user.id)
  #        when permission_for(user)=='medrescollaborator' then return Contact.where(user_id: user.id)

			  end

			  return schoolyearlist

	end


  # user = current user
	def display_student_for(user)

			profile = case

			when permission_for(user)=='admin' then @registration.student.contact.name_and_institution
			when permission_for(user)=='papmgr' then @registration.student.contact.name_and_institution

	#		when permission_for(user)=='pap' then "Usuário (Pap)"
	#		when permission_for(user)=='papcollaborator' then "Colaborador Pap (externo) "
			when permission_for(user)=='paplocaladm' then @registration.student.contact.name
	#		when permission_for(user)=='medres' then "Residência Médica"
	#		when permission_for(user)=='medrescollaborator' then "Colaborador Residência Médica "
	#		when permission_for(user)=='medreslocaladm' then "COREME"
	#		when permission_for(user)=='medresmgr' then "Gerente da Residência Médica"
			when permission_for(user)=='adminreadonly' then "Somente leitura - Read-only"
			else "indefinido"
		  end

			return profile.html_safe

	end

	# Schoolyears
	def display_student_program_for(user)

			profile = case

			when permission_for(user)=='admin'  then :program_name_term_institution_short
			when permission_for(user)=='papmgr'  then :program_name_term_institution_short

	#		when permission_for(user)=='pap' then "Usuário (Pap)"
	#		when permission_for(user)=='papcollaborator' then "Colaborador Pap (externo) "
	#    when permission_for(user)=='paplocaladm' then :name
	    when permission_for(user)=='paplocaladm' then :program_name_schoolterm

	#		when permission_for(user)=='papmgr' then "Gerente do PAP"
	#		when permission_for(user)=='medres' then "Residência Médica"
	#		when permission_for(user)=='medrescollaborator' then "Colaborador Residência Médica "
	#		when permission_for(user)=='medreslocaladm' then "COREME"
	#		when permission_for(user)=='medresmgr' then "Gerente da Residência Médica"
	# 		when permission_for(user)=='adminreadonly' then "Somente leitura - Read-only"
			else "indefinido"
		  end

			return profile

	end

end
