module AnnotationsHelper

		# Implemented in preparation of local administrators' initial training
	def annotations_exist_for?(user)
	
			return @num_annotations>0
			
			# visibility is given by the user's permission (implicitly)
	
	end			

	def display_attendance(annotation)

			return (days_for_month(annotation.payroll.monthworked)-annotation.absences).to_s.html_safe
			
									
	end

	def display_event_kind(event)

			txt=''
				
			if event.leave? 
				
				txt=tm('leave').capitalize+' '+event.leavetype.name
				
			else
			
				txt=ta('event.absence')
				
			end

			return txt.html_safe
									
	end

  # Fetch students 
	def registrations_for(user)
	
				records = case
				
	        when permission_for(user)=='admin' then Registration.all
	        when permission_for(user)=='papmgr' then Registration.pap
	        when permission_for(user)=='paplocaladm' then Registration.pap.from_own_institution(user)
				  end	 				
			  
			  return records
	end			
		
	def registration_details(user)

			profile = case

			when permission_for(user)=='admin' then :full_details		
			when permission_for(user)=='papmgr' then :full_details		
			when permission_for(user)=='paplocaladm' then :details		
			else "indefinido"
		  end		 
		  
			return profile
				 		 
	end

	
	
end
