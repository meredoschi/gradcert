module ProgramsHelper

	def registered_students(schoolyear)

			return schoolyear.number_registered_students			 	
	
	end		
	
	def teaching_areas(program)

		txt=''
		
		if program.pap
		
			txt=txt+t('abbreviation.pap')+' '
			
		end


		if program.pap
		
			txt=txt+t('abbreviation.medicalresidency')
			
		end
		
		return txt.html_safe  
				
			
	end
		
	def is_multiyear?(program)			

#   		if program.duration>1 && program.following_years_annual_grants.present? && program.following_years_total_enrollment.present?
		
			 return true
			
# 		else
		
# 			return false
			
	# 	end
			
	end

	def internal_venue?(program)			

       if program.externalvenue
		
				 return false
			 
			 else
			 
			 	return true
			 	
			 end
			
	end

	def is_inactive?(program)			

       if program.is_active?
		
				 return false
			 
			 else
			 
			 	return true
			 	
			 end
			
	end
	
	def is_first(schoolyear)			

       if schoolyear.programyear==1
		
				 return true
			 
			 else
			 
			 	return false
			 	
			 end
			
	end


		def display_duration			

			txt="---"

			d=@program.duration
			
			txt+=d
			
#   		if program.duration>1 && program.following_years_annual_grants.present? && program.following_years_total_enrollment.present?
		
			 txt.html_safe
			
# 		else
		
# 			return false
			
	# 	end
			
		end

	def retrieve_schoolterms_for(user)
		
		names = case
		
		  when is_admin_or_readonly(user) then Schoolterm.find_active_schoolterms 
		  when is_pap_manager(user) then Schoolterm.find_active_pap_schoolterms  				
		  when is_medres_manager(user) then Schoolterm.find_active_medres_schoolterms
		 						 	
		return names
		  
		end	 				
		
	end		
		

	def retrieve_programnames_for(user)
		
		names = case
		
		  when is_admin_or_readonly(user) then Program.find_active_programnames 
		  when is_pap_manager(user) then Program.find_active_pap_programnames				
		  when is_medres_manager(user) then Program.find_active_medres_programnames
		  # when pap_staff?(user) then Program.find_active_programnames.pap 
      # when is_medres_staff(user) then Program.find_active_programnames.medres 
      # if local admins where allowed to create, read, update them.  Comment manager lines above accordingly if so.
		 						 	
		return names
		  
		end	 				
		
	end		
		
	def confirm_teaching_area(user, f)
	
				profile = case
				
	        when permission_for(user)=='admin' then render partial: 'form_belongs_to', locals: { f: f } 		
				  when permission_for(user)=='medresmgr' then  render partial: 'form_belongs_to_medres', locals: { f: f }
				  when permission_for(user)=='papmgr' then  render partial: 'form_belongs_to_pap', locals: { f: f }				
				
				end	 				
							
	end

end