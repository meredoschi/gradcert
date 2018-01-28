module CoursesHelper


	def active_programs_for(user, f)
	
				profile = case
				
	        when permission_for(user)=='admin' then render partial: 'form_active_programs', locals: { f: f } 		
				  when permission_for(user)=='medresmgr' then  render partial: 'form_medres_programs', locals: { f: f }
				  when permission_for(user)=='papmgr' then  render partial: 'form_pap_programs', locals: { f: f }		
				  when permission_for(user)=='paplocaladm' then  render partial: 'form_pap_local_programs', locals: { f: f }			
					when permission_for(user)=='medreslocaladm' then  render partial: 'form_medres_local_programs', locals: { f: f }				
				end	 				
							
	end
	
	def supervisors_for(user, f)
	
				profile = case
				
	        when permission_for(user)=='admin' then render partial: 'form_supervisors', locals: { f: f } 		
				  when permission_for(user)=='medresmgr' then  render partial: 'form_medres_supervisors', locals: { f: f }
				  when permission_for(user)=='papmgr' then  render partial: 'form_pap_supervisors', locals: { f: f }		
				  when permission_for(user)=='paplocaladm' then  render partial: 'form_pap_supervisors_own_institution', locals: { f: f }			
					when permission_for(user)=='medreslocaladm' then  render partial: 'form_medres_supervisors_own_institution', locals: { f: f }				
				end	 				
							
	end


	def professional_family_list_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return Professionalfamily.all
          when permission_for(user)=='papmgr'  || 'papcollaborator' then return Professionalfamily.pap				
          when permission_for(user)=='medresmgr' || 'medrescollaborator'  then return Professionalfamily.medres				
          
			  else
			  
			  return
			  			false			  			
			  end	 											
	end

	def practice_or_theory?(course)

		if course.is_practical?
		
			return t('practical').html_safe
			
		else

			return t('theoretical').html_safe
		
		end		
		
	end

	def core?(course)

		if course.is_core?
		
			return ta('course.core').html_safe
					
		end		
		
	end	

	def professional_requirement?(course)

		if course.is_professionalrequirement?
		
			return ta('course.professionalrequirement').html_safe
					
		end		
		
	end	
		
end