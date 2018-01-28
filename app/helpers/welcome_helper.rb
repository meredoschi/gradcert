module WelcomeHelper
  
  def display_department_name(user)

    profile = case

    when belongs_to_pap(user) then ta('programname.pap')
    when belongs_to_medres(user) then ta('programname.medres')
    when is_admin(user) then "Admin"
    when is_adminreadonly(user) then "Readonly"  
    else
      return profile

    end	 				
	end

  def display_brazilian_salutation(user)

    personalinfo=user.contact.personalinfo
    
    if personalinfo.genderdiversity?
      
      txt='Boas vindas! '
    
    else
      
      txt='Seja bem vind'

      if user.contact.female?
        
        txt+='a! '
      else
        txt+='o! '
        
      end
    
    txt+=user.contact.name
    
    end    
        
  end
  
  # Welcome screen 
  def belongs_to_pap(user)

		  return user.permission.kind.in?(['pap','papcollaborator','paplocaladm','papmgr'])

	end
	
	def belongs_to_medres(user)

		  return user.permission.kind.in?(['medres','medrescollaborator','medreslocaladm','medresmgr'])

	end
  
end
