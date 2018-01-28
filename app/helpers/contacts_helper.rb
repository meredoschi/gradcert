module ContactsHelper

	def uses_social_networks?(contact)

		 if (contact.webinfo.facebook.present?) || (contact.webinfo.twitter.present?) || (contact.webinfo.other.present?)

		 	return true

		 else

		 	return false

		 end

	end

	def has_personal_email_or_site?(contact)

		 if (contact.webinfo.site.present?) || (contact.webinfo.email.present?)

		 	return true

		 else

		 	return false

		 end

	end

	def gender_diversity?(contact)

		result=false

		if contact.personalinfo.present?

			 if (contact.personalinfo.gender.present? && contact.personalinfo.sex!=contact.personalinfo.gender) || contact.personalinfo.sex=='X' || contact.personalinfo.gender=='X'

		  	result=true

			 end

		end

		return result

	end

	def is_international(country)

			if country.a3!='BRA'

			return true

			else

				return false

			end

	end


	def is_own_contact(user)

			if @contact.user==current_user

			return true

			else

				return false

			end

	end

	def has_management_role(contact)

		if contact.role

		  if contact.role.management==true

				return true

	     else

	    	return false

	    end

		end

	end

 # gives the full name for personal characteristic abbreviations (sex and gender), F, M, X
	def fulldescription(abbreviation)

				profile = case

	        when abbreviation=='X' then return t('gender.X')
	        when abbreviation=='M' then return t('gender.M')
	        when abbreviation=='F' then return t('gender.F')

			  end
	end

	def retrieve_internal_roles_for(user)

				profile = case

	        when permission_for(user)=='admin' then return Role.internal
          when permission_for(user)=='papmgr'then return Role.internal.pap
          when permission_for(user)=='medresmgr' then return Role.internal.medres
#					when permission_for(user)=='paplocaladm' then return Role.paplocal
					when permission_for(user)=='paplocaladm' then return Role.paplocal

#           when permission_for(user)=='paplocaladm' then return Role.pap.student

          when permission_for(user)=='medreslocaladm' then return Role.internal.medres
			  end
	end

	def actual_internal_roles_for(user)

				profile = case

	        when permission_for(user)=='admin' then return Role.internal.joins(:contact)
          when permission_for(user)=='papmgr'then return Role.internal.pap.joins(:contact)
          when permission_for(user)=='medresmgr' then return Role.internal.medres.joins(:contact)
          when permission_for(user)=='paplocaladm' then return Role.internal.pap.joins(:contact)
          when permission_for(user)=='medreslocaladm' then return Role.internal.medres.joins(:contact)
			  end
	end

	def retrieve_collaborator_roles_for(user)

				profile = case

	        when permission_for(user)=='admin' then return Role.collaborator.joins(:contact)
          when permission_for(user)=='papmgr'then return Role.collaborator.pap.joins(:contact)
          when permission_for(user)=='medresmgr' then return Role.collaborator.medres.joins(:contact)
          when permission_for(user)=='paplocaladm' then return Role.collaborator.pap.joins(:contact)
          when permission_for(user)=='medreslocaladm' then return Role.collaborator.medres.joins(:contact)
			  end
	end

	def all_collaborator_roles_for(user)

				profile = case

	        when permission_for(user)=='admin' then return Role.collaborator
          when permission_for(user)=='papmgr'then return Role.collaborator.pap
          when permission_for(user)=='medresmgr' then return Role.collaborator.medres
          when permission_for(user)=='paplocaladm' then return Role.collaborator.pap
          when permission_for(user)=='medreslocaladm' then return Role.collaborator.medres
			  end
	end

end
