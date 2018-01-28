module StatesHelper

	def display_if_foreign(country)
	
		   if country.a3!=Settings.home_country_abbreviation
			
				return country.brname.html_safe
			
			end
	end

end