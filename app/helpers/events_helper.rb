module EventsHelper

	# Implemented in preparation of local administrators' initial training
	def events_exist_for?(user)

			return @num_events>0

			# visibility is given by the user's permission (implicitly)

	end

  # Fetch students
	def active_registrations_for(user)

				records = case

				when permission_for(user)=='admin' then @active_registrations
				when permission_for(user)=='papmgr' then @active_registrations
				when permission_for(user)=='paplocaladm' then @active_registrations

  			end

			  return records
	end


=begin
	def registration_details(user)

			profile = case

			when permission_for(user)=='admin' then :student_name_id_schoolyear_terms
			when permission_for(user)=='papmgr' then :student_name_id_schoolyear_term
			when permission_for(user)=='paplocaladm' then :student_name_id_schoolyear_term
			else "indefinido"
		  end

			return profile

	end
=end

	def index_kind(event)

			if event.residual?

				txt=''

			else

				if event.leave?

					txt=tm('leave').capitalize+' '+event.leavetype.name

				else

					txt=ta('event.absence')

				end

			end

			return txt.html_safe

	end

	def show_kind(event)

			if event.residual?

				txt=ta('event.residual')

			else

				if event.leave?

					txt=tm('leave').capitalize+' '+event.leavetype.name

				else

					txt=ta('event.absence')

				end

			end

			return txt.html_safe

	end

	def display_residual_warning?(event)

			txt=''

			if event.residual?

				txt=ta('event.residual')

			end

			return txt.html_safe

	end
=begin

	def display_if_is_leave(event)

			txt=''

			if event.leave?

				txt=event.leavetype.name

			else

				txt='---'

			end

			return txt.html_safe

	end

	def display_if_is_absence(event)

			txt=''

			if event.absence?

				txt=tickmark(event.absence)

			else

				txt='---'

			end

			return txt.html_safe

	end

=end

end
