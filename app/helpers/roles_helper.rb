module RolesHelper

	def role_search_options(user)
	
				profile = case
				
          when permission_for(user)=='adminreadonly' then  render partial: 'index_search_belongs_to.html.erb'										  
				  when permission_for(user)=='admin' then  render partial: 'index_search_belongs_to.html.erb'	 					
        #   when permission_for(user)=='papmgr' then  render partial: 'index_search_belongs_to_pap.html.erb'						
        #   when permission_for(user)=='medresmgr' then  render partial: 'index_search_belongs_to_medres.html.erb'				
				
				end	 				
							
	end	
	
	def role_profiles(user, f)

			profile = case
			
			when permission_for(user)=='admin' then render partial: 'form_admin_profile', locals: { f: f } 		
			when permission_for(user)=='medresmgr' then render partial: 'form_medres_manager_profile', locals: { f: f }				
			when permission_for(user)=='papmgr'  then render partial: 'form_pap_manager_profile', locals: { f: f }			
		  end	 				
	end		
						
end