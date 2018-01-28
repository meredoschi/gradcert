module InstitutionsHelper
		
	def uses_internet_social_media?(institution)

		if institution.webinfo.facebook || institution.webinfo.twitter || institution.webinfo.other 
			
				return true
				
			else
			
				return false
	
			end
			 					 
	end
	

	def with_website_or_email?(institution)
	
			if institution.webinfo.site || institution.webinfo.email 
			
				return true
				
			else
			
				return false
	
			end
			 					 
	end

	def display_website(institution)
	
			if institution.webinfo.site  
			
				return institution.webinfo.site.html_safe
					
			end
			 					 
	end
	
	def display_if_exists(institution)
	
# 	     if (institution.url!=nil && institution.url.length>3) 
		
		     link_to institution.url, "http://#{institution.url}", :target => '_blank'
		 	
	# 	 	end

	end

  def available_infrastructure(institution)

			txt=''
					
			if institution.with_research_center?
			
					txt+=tm('researchcenter').capitalize	
					
			end
	
			if institution.with_college?
			
					txt+=', '
					txt+=tm('college').capitalize	
					
			end

			if institution.with_healthcare_info?

					txt+=', '			
					txt+=tm('healthcareinfo').capitalize	
					
			end
			
			return txt.html_safe

	end


	def teaching_offerings(institution)

			txt=''
					
			if institution.undergraduate
			
					txt+=ta('institution.undergraduate')	
					
			end
	
			if institution.with_pap_programs?
			
					txt+=' '
					txt+=ta('institution.pap')	
					
			end

			if institution.with_medres_programs?

					txt+=' '			
					txt+=ta('institution.medres')	
					
			end
			
			return txt.html_safe
			
	 end	 					
											
  # More generic method - takes an object with webinfo nested model.  Could be an institution, council, etc.
	def weblink(obj)
	 
 		if (obj.webinfo.site!=nil && obj.webinfo.site.length>3) 
	 		
 			 link_to image_tag('site.png', alt: obj.webinfo.site), "http://#{obj.webinfo.site}", :target => '_blank', data: { confirm: I18n.t("confirm.visit_external_site")}
	
 		end
	
	end	

	
	def www_globe(institution)
	 
 		if (institution.webinfo.site!=nil && institution.webinfo.site.length>3) 
	 		
 			 link_to image_tag('site.png', alt: institution.webinfo.site), "http://#{institution.webinfo.site}", :target => '_blank', data: { confirm: I18n.t("confirm.visit_external_site")}
	
 		end
	
	end	
	
	def last_updated_by(institution)
			
			if (institution.user_id!=nil)

					html = ""

					html += with_user(institution).id.to_s()
		
					return html.html_safe
						
			end
		  
	end


	def is_verified(institution)
			
			if (institution.provisional)

					return false

		  else
		  		
		  		return true			
					
			end		
					
	end

	def permitted_institution_options(user, f)
	
				profile = case

				  when permission_for(user)=='medresmgr' then  render partial: 'institutions/medres/form_department_responsible.html.erb', locals: { f: f }				
				  when permission_for(user)=='papmgr' then  render partial: 'institutions/pap/form_department_responsible.html.erb', locals: { f: f }			
  			  when permission_for(user)=='admin' then  render partial: 'institutions/admin/form_department_responsible.html.erb', locals: { f: f }			
		
			  end	 				
							
	end

=begin
	
	def institution_search_options(user)
	
				profile = case
				
					when permission_for(user)=='adminreadonly' then  render partial: 'institutions/admin/index_search_admin.html.erb'										  
				  when permission_for(user)=='admin' then  render partial: 'institutions/admin/index_search_admin.html.erb'						
				  when permission_for(user)=='papmgr' then  render partial: 'index_search_pap_manager.html.erb'						
				  when permission_for(user)=='medresmgr' then  render partial: 'index_search_medres_manager.html.erb'				

			  end	 				
							
	end	

=end

# Revised

	def institution_with_programs_exists_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' && Institution.with_programs.count>0 then return true 		
				  when permission_for(user)=='papmgr' && Institution.with_programs.pap.count>0 then return true 				
			    when permission_for(user)=='medresmgr' && Institution.with_programs.medres.count>0 then return true 							
				#   when permission_for(user)=='paplocaladm' && Institution.for_user(current_user).pap.count>0 then return true				
	      #   when permission_for(user)=='medreslocaladm' && Institution.for_user(current_user).medres.count>0 then return true				
				else
					return false
			  end	 				
							
	end	
	
	def retrieve_label_institutions_with_programs_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return t('activerecord.attributes.institution.withprograms.any') 		
				  when permission_for(user)=='papmgr'then return t('activerecord.attributes.institution.withprograms.pap') 				
			    when permission_for(user)=='medresmgr' then return t('activerecord.attributes.institution.withprograms.medres')
				else
					return false
			  end	 				
							
	end	

	def retrieve_institutions_with_programs_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return Institution.with_active_programs 		
				  when permission_for(user)=='papmgr'then return Institution.with_programs.pap 				
			    when permission_for(user)=='medresmgr' then return Institution.with_programs.medres 								
				else
					return false
			  end	 				
							
	end	
	
end