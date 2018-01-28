module ProgramsituationsHelper

	# return assessment count for the user
		def assessment_count_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return Assessment.without_situation.count
          when permission_for(user)=='papmgr' then return Assessment.without_situation.pap.count				
          when permission_for(user)=='medresmgr' then return Assessment.without_situation.medres.count
          # programs are previously filtered by area
          when permission_for(user)=='papcollaborator' then return Assessment.without_situation.pap.own(user).count
          when permission_for(current_user)=='medrescollaborator' then return Assessment.without_situation.medres.own(user).count
        else
						return false    			
			  end	 				
							
	end

	def assessments_exist?(user)

		if assessment_count_for(user) > 0 then

			return true
		
		else
		
			return false
			
		end		

	end

	def assessments_for(user)
	
				profile = case
				
	        when permission_for(user)=='admin' then return Assessment.without_situation
          when permission_for(user)=='papmgr' then return Assessment.without_situation.pap				
          when permission_for(user)=='medresmgr' then return Assessment.without_situation.medres
          # programs are previously filtered by area
          when permission_for(user)=='papcollaborator' then return Assessment.without_situation.pap.own(user)
          when permission_for(current_user)=='medrescollaborator' then return Assessment.without_situation.medres.own(user)
        else
						return false    			
			  end	 				
							
	end
		
	def duration_change_recommended?

		if @programsituation.recommended_duration.to_i!=@programsituation.assessment.program.duration.to_i	
	
			return true
		
		else
			
			return false
			
		end
		
	end

	def favorable_opinion?

		if @programsituation.favorable	
	
			return true
		
		else
			
			return false
			
		end
		
	end
	
	def workload_change_recommended?

		if @programsituation.workload.to_i!=@programsituation.assessment.program.workload.to_i	
	
			return true
		
		else
			
			return false
			
		end
		
	end
end