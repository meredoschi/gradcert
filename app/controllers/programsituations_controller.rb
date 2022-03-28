class ProgramsituationsController < ApplicationController
  before_action :set_programsituation, only: [:show, :edit, :update, :destroy]
  before_action :set_max_duration

	before_action :set_schoolyears, :only => [:show, :edit, :update]
 
	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /programsituations
  def index
				
		@title=t('list')+' '+t('activerecord.models.programsituation').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('situation').to_s.upcase
      @title+=' | '+t('activerecord.models.programsituation').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('situation').to_s.upcase
        @title+=' | '+t('activerecord.models.programsituation').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('programsituation').pluralize.to_s.upcase
    		
  		end
  		  
    end

  	@search = Programsituation.accessible_by(current_ability).ransack(params[:q])
  	@programsituations=@search.result.page(params[:page]).per(10)
		# @numassessments=Assessment.count
		@numprogramsituations=Programsituation.accessible_by(current_ability).count
      

  end

  # GET /programsituations/1
  def show
  
  	@title=t('activerecord.models.programsituation').capitalize.to_s   

#   	@schoolyears=Schoolyear.all

#   	@schoolyears=Schoolyear.for_program(357)
 
#  	if !@programsituation.name.nil?
    
#    	@title=@title+": "+@programsituation.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('situation').to_s.upcase+" | "+t('activerecord.models.programsituation').capitalize
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('situation').to_s.upcase+' | '+t('activerecord.models.programsituation').capitalize
  			
			else
					
				@title=tm('programsituation').pluralize.upcase.to_s

				if !@programsituation.name.nil? 
				
					@title+=" : "+@programsituation.name
				
				end	
				
			end
			
		end

  end

  # GET /programsituations/new
  def new
    @programsituation = Programsituation.new

    if is_admin_or_manager(current_user)
    
			@title=t('situation').to_s.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.programsituation')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.programsituation')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.programsituation')  			
			
			end

		end

		for i in 1..@maxduration
	   		@programsituation.recommendations.build(grants:0, theory:0, practice:0)
			end
    
  end

  # GET /programsituations/1/edit
  def edit

 
#     @title=t('noun.edit')+" "+t('activerecord.models.programsituation')

    if is_admin_or_manager(current_user) 

				@title=t('situation').to_s.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.programsituation')

    	else

			if is_local_admin(current_user) 

				@title=t('situation').to_s.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.programsituation')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('programsituation')

			end
  	
  	end

  end

  # POST /programsituations
  def create
    @programsituation = Programsituation.new(programsituation_params)

    if @programsituation.save
      redirect_to @programsituation, notice: t('activerecord.models.programsituation').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /programsituations/1
  def update

    if @programsituation.update(programsituation_params)
     # redirect_to @programsituation, notice: 'Programsituation was successfully updated.'
       redirect_to @programsituation, notice: t('activerecord.models.programsituation').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /programsituations/1
  def destroy
    @programsituation.destroy
    redirect_to programsituations_url, notice: t('activerecord.models.programsituation').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programsituation
      @programsituation = Programsituation.find(params[:id])
    end

	def set_schoolyears

		@schoolyears=Schoolyear.for_program(@programsituation.assessment.program_id)

	end

	def set_max_duration

		profile = case
				
	        when is_pap_staff(current_user) then @maxduration=Settings.longest_program_duration.pap 	
	        when is_pap_collaborator(current_user) then @maxduration=Settings.longest_program_duration.pap 	
	        when is_medres_staff(current_user) then @maxduration=Settings.longest_program_duration.medres 	
	        when is_medres_collaborator(current_user) then @maxduration=Settings.longest_program_duration.medres 	
 		
				else
					@maxduration=Settings.longest_program_duration.all

		end	 				

	end

    # Only allow a trusted parameter "white list" through.
    def programsituation_params
      params.require(:programsituation).permit(:assessment_id, :favorable, :duration_change_requested, :recommended_duration, :goals, :kind, recommendations_attributes: [:id, :programyear, :programsituation_id, :grants, :theory, :practice, :_destroy])
    end
end
