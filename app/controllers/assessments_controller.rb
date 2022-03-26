class AssessmentsController < ApplicationController
  before_action :set_assessment, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /assessments
  def index
    @assessments = Assessment.all

		@title=t('list')+' '+t('activerecord.models.assessment').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('situation').mb_chars.upcase
      @title+=' | '+t('activerecord.models.assessment').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('situation').mb_chars.upcase
        @title+=' | '+t('activerecord.models.assessment').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('assessment').pluralize.mb_chars.upcase
    		
  		end
  		  
    end
       

  	@search = Assessment.accessible_by(current_ability).ransack(params[:q])
		# @assessments=@search.result.page(params[:page]).per(10)
	  
  	@assessments=@search.result.includes(:contact, :profession, :program).page(params[:page]).per(10)
		# @numassessments=Assessment.count
		
		@numassessments=Assessment.accessible_by(current_ability).count

  end

  # GET /assessments/1
  def show
  	@title=t('activerecord.models.assessment').capitalize   
 
#  	if !@assessment.name.nil?
    
#    	@title=@title+": "+@assessment.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('situation').mb_chars.upcase+" | "+t('activerecord.models.assessment').capitalize
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('situation').mb_chars.upcase+' | '+t('activerecord.models.assessment').capitalize
  			
			else
					
				@title=tm('assessment').pluralize.upcase
								
			end
			
		end

  end

  # GET /assessments/new
  def new
    @assessment = Assessment.new

    if is_admin_or_manager(current_user)
    
			@title=t('situation').mb_chars.upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.assessment')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.assessment')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.assessment')  			
			
			end

		end
    
  end

  # GET /assessments/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.assessment')

    if is_admin_or_manager(current_user) 

				@title=t('situation').mb_chars.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.assessment')

    	else

			if is_local_admin(current_user) 

				@title=t('situation').mb_chars.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.assessment')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('assessment').pluralize

			end
  	
  	end

  end

  # POST /assessments
  def create
    @assessment = Assessment.new(assessment_params)

    if @assessment.save
      redirect_to @assessment, notice: t('activerecord.models.assessment').capitalize+' '+t('created.f')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /assessments/1
  def update
    if @assessment.update(assessment_params)
     # redirect_to @assessment, notice: 'Assessment was successfully updated.'
       redirect_to @assessment, notice: t('activerecord.models.assessment').capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /assessments/1
  def destroy
    @assessment.destroy
    redirect_to assessments_url, notice: t('activerecord.models.assessment').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment
      @assessment = Assessment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def assessment_params
      params.require(:assessment).permit(:contact_id, :program_id, :profession_id, :duration_change_requested, :expected_duration, :expected_first_year_grants, :expected_second_year_grants, :summary_of_program_goals, :program_nature_vocation, :first_year_theory_hours, :first_year_practice_hours, :second_year_theory_hours, :second_year_practice_hours, roles_attributes: [:collaborator, :teaching])
    end
end
