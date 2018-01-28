module MakeupschedulesHelper

  # Copied from events helper

  def registration_details(user)

			profile = case

			when permission_for(user)=='admin' then :full_details
			when permission_for(user)=='papmgr' then :full_details
			when permission_for(user)=='paplocaladm' then :report_details
			else "indefinido"
		  end

			return profile

	end

end
