module AbsentreportsHelper

  # i = index
  def display_institution_name_for(registration, i)

      if is_admin_or_manager(current_user) && (@institution_indices.include? i)

  		    return registration.institution.html_safe # institution_name (defined in the model)

      else

          return nil

      end

	end


end
