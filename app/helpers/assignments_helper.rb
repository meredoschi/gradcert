module AssignmentsHelper

	def supervisors_exist_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' && Supervisor.count>0 then return true 		
				  when permission_for(user)=='papmgr' && Supervisor.pap.count>0 then return true 				
				  when permission_for(user)=='paplocaladm' && Supervisor.from_own_institution(current_user).pap.count>0 then return true				
	        when permission_for(user)=='medresmgr' && Supervisor.medres.count>0 then return true 				
	        when permission_for(user)=='medreslocaladm' && Supervisor.from_own_institution(current_user).medres.count>0 then return true				
	        when permission_for(user)=='pap' && Supervisor.exists_for_supervisor?(current_user) then return true				
					when permission_for(user)=='medres' && Supervisor.exists_for_supervisor?(current_user) then return true				
					when permission_for(user)=='papcollaborator' && Supervisor.exists_for_supervisor?(current_user) then return true				
					when permission_for(user)=='medrescollaborator' && Supervisor.exists_for_supervisor?(current_user) then return true				
	
				else
					return false
			  end	 				
							
 	end

	def programs_exist_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' && Program.count>0 then return true 		
				  when permission_for(user)=='papmgr' && Program.pap.count>0 then return true 				
				  when permission_for(user)=='paplocaladm' && Program.from_own_institution(current_user).pap.count>0 then return true				
	        when permission_for(user)=='medresmgr' && Program.medres.count>0 then return true 				
	        when permission_for(user)=='medreslocaladm' && Program.from_own_institution(current_user).medres.count>0 then return true				
				  when permission_for(user)=='pap' && Program.exists_for_supervisor?(current_user) then return true				
					when permission_for(user)=='medres' && Program.exists_for_supervisor?(current_user) then return true				
					when permission_for(user)=='papcollaborator' && Program.exists_for_supervisor?(current_user) then return true				
					when permission_for(user)=='medrescollaborator' && Program.exists_for_supervisor?(current_user) then return true				
				else
					return false
			  end	 				
							
	end

	def retrieve_supervisors_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return Supervisor.all
          when permission_for(user)=='papmgr'then return Supervisor.pap				
          when permission_for(user)=='medresmgr' then return Supervisor.medres				
          when permission_for(user)=='paplocaladm' then return Supervisor.from_own_institution(current_user).pap				
          when permission_for(user)=='medreslocaladm' then return Supervisor.from_own_institution(current_user).medres				
          
			  end	 				
							
	end

	def supervisor_type(assignment)
	
			if assignment.main==true
			
			html=ta('supervisor.main')
			
			else
			
				html=ta('supervisor.alternate')    			
			
			end
			
		 return html.html_safe

	end
			
end