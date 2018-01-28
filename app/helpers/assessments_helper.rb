module AssessmentsHelper

	def assessor_list_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return Contact.with_evaluator_role
          when permission_for(user)=='papmgr'  || 'papcollaborator' then return Contact.with_evaluator_role.pap				
          when permission_for(user)=='medresmgr' || 'medrescollaborator'  then return Contact.with_evaluator_role.medres				
          when permission_for(user)=='paplocaladm'then return Contact.with_evaluator_role.from_own_institution(current_user).pap				
          when permission_for(user)=='medreslocaladm' then return Contact.with_evaluator_role.from_own_institution(current_user).medres				
          
			  else
			  
			  return
			  			false
			  			
			  end	 				
							
	end
	
	def assessment_name_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return :name
          when permission_for(user)=='papmgr' then return :name				
          when permission_for(user)=='medresmgr' then return :name 				
          when permission_for(user)=='papcollaborator'then return :name_without_contact				
          when permission_for(user)=='medrescollaborator' then return :name_without_contact				
          
			  else
			  
			  return
			  			false
			  			
			  end	 				
							
	end
	
end