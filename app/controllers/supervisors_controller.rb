class SupervisorsController < ApplicationController
  before_action :set_supervisor, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user!

 # Marcelo - CanCan
	load_and_authorize_resource 

  # GET /supervisors
  # GET /supervisors.json
  def index
    # @supervisors = Supervisor.all

  	if is_admin_or_manager(current_user)    

			@title=t('people').upcase+" | "+t('activerecord.models.supervisor').pluralize.capitalize
    
    else

 	 		if is_local_admin(current_user)    

				@title=t('people').upcase+' | '+t('activerecord.models.supervisor').capitalize.pluralize
  
  		else
			# i.e. regular user or collaborator

				@title=t('personal_info').mb_chars.upcase+' | '+t('my_teaching').mb_chars.capitalize
			
			end
			  		
  		  
    end
			  
		# https://github.com/ryanb/cancan/wiki/Fetching-Records
	# 	@users=User.accessible_by(current_ability, :update)
	  @search = Supervisor.accessible_by(current_ability).ransack(params[:q])
  	@supervisors=@search.result.page(params[:page]).per(10)
    @numsupervisors=@supervisors.count

  end

  # GET /supervisors/1
  # GET /supervisors/1.json
  def show
  	  	 	
    if @supervisor.contact.user==current_user || is_regular_user(current_user)


			@title=t('personal_info').mb_chars.upcase+' | '+t('my_teaching').mb_chars.capitalize+' | '+t('actions.show')

		else

	   	 @title=t('people').pluralize.upcase+' | '+tm('supervisor').capitalize+' | '+t('actions.show')  
									
		end
		 	  
  end

  # GET /supervisors/new
  def new
		
	   	@title=t('people').pluralize.upcase+' | '+tm('supervisor').capitalize+' | '+t('actions.new.m')  
	   	@supervisor.diploma.build
	   	# Pluralization in english diploma ends with an a, plural!
												
  end

  # GET /supervisors/1/edit
  def edit
    	   	
    if @supervisor.contact.user==current_user || is_regular_user(current_user)

			@title=t('personal_info').mb_chars.upcase+' | '+t('my_teaching').mb_chars.capitalize+' | '+t('actions.edit')
		
		else

	   	 @title=t('people').pluralize.upcase+' | '+tm('supervisor').capitalize+' | '+t('actions.edit')  
									
		end
	 
  end

  # POST /supervisors
  # POST /supervisors.json
  def create
  
    @supervisor = Supervisor.new(supervisor_params)

    respond_to do |format|
      if @supervisor.save
        format.html { redirect_to @supervisor, notice: t('activerecord.models.supervisor').capitalize+' '+t('created.m')+' '+t('succesfully') }        
        format.json { render action: 'show', status: :created, location: @supervisor }
      else
        format.html { render action: 'new' }
        format.json { render json: @supervisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supervisors/1
  # PATCH/PUT /supervisors/1.json
  def update
    respond_to do |format|
      if @supervisor.update(supervisor_params)

				if is_not_regular_user(current_user)
        	format.html { redirect_to @supervisor, notice: t('activerecord.models.supervisor').capitalize+' '+t('updated.m')+' '+t('succesfully') }
				else
					format.html { redirect_to @supervisor, notice: t('supervisor_professional_data').capitalize+' '+t('updated.m').pluralize+' '+t('succesfully') }			
				end
				      
        format.json { head :no_content }
        
      else
        format.html { render action: 'edit' }
        format.json { render json: @supervisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supervisors/1
  # DELETE /supervisors/1.json
  def destroy
    @supervisor.destroy
    respond_to do |format|
      format.html { redirect_to supervisors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supervisor
      @supervisor = Supervisor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supervisor_params
      params.require(:supervisor).permit(:contact_id, :program, :course, :career_start_date, :profession_id, :highest_degree_held, :graduation_date, :contract_type, assignments_attributes: [:program_id, :supervisor_id, :start_date, :main], diploma_attributes: [:id, :institution_id, :profession_id, :degreetype_id, :externalinstitution, :ongoing, :awarded, :_destroy])
    end
end