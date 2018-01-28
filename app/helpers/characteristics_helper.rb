module CharacteristicsHelper

	def currency_or_percent(characteristic)
	
			if characteristic.funding.percentvalues then
			
				return "%".html_safe
				
			else

				return "R$".html_safe
			
			end		
				
  end

	def display_comment_if_exists
	
			if @characteristic.funding.comment.present? then
			
				return @characteristic.funding.comment.html_safe
				
			else

				return "".html_safe
			
			end		
				
  end
 
end