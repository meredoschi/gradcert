class CollegesController < ApplicationController
  before_action :set_college, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /colleges
  def index
    @colleges = College.all
    
    if is_admin_or_manager(current_user)    

			@title=t('entity').to_s.pluralize.upcase+' | '+tm('college').pluralize.capitalize
    
    else

			@title=t('my.f').upcase+' '+t('entity').to_s.upcase+' | '+tm('college').capitalize
    
    end
    
  	@search = College.accessible_by(current_ability).ransack(params[:q])
  	@colleges=@search.result.page(params[:page]).per(10)
		@numcolleges=College.count

  end

  # GET /colleges/1
  def show
  
		if is_admin_or_manager(current_user)
		
			@title=t('entity').to_s.pluralize.upcase+' | '+tm('college').capitalize+' | '+t('actions.show')
		
		else

			@title=t('my.f').upcase+' '+t('entity').to_s.upcase+' | '+tm('college').capitalize+' | '+t('actions.show')

		end

  end

  # GET /colleges/new
  def new
    @college = College.new
    
    if is_admin_or_manager(current_user)
  	 	
	   	 @title=t('entity').to_s.pluralize.upcase+' | '+tm('college').pluralize.capitalize+' | '+t('actions.new.f')  

		else

			 @title=t('my.f').upcase+" "+t('entity').to_s.upcase+' | '+tm('college').capitalize+' | '+t('actions.new.f')		 
		 
		end   

        
  end

  # GET /colleges/1/edit
  def edit

		if is_admin_or_manager(current_user)
		
			@title=t('entity').to_s.pluralize.upcase+' | '+tm('college').capitalize+' | '+t('actions.edit')
		
		else

			@title=t('my.f').upcase+' '+t('entity').to_s.upcase+' | '+tm('college').capitalize+' | '+t('actions.edit')

		end

     	 
  end

  # POST /colleges
  def create
    @college = College.new(college_params)

    # treat for local admin
	 	if is_local_admin(current_user)    
      @college.institution_id=current_user.institution_id    
    end

    if @college.save
      redirect_to @college, notice: t('activerecord.models.college').capitalize+' '+t('created.f')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /colleges/1
  def update
    if @college.update(college_params)
     # redirect_to @college, notice: 'College was successfully updated.'
       redirect_to @college, notice: t('activerecord.models.college').capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /colleges/1
  def destroy
    @college.destroy
    redirect_to colleges_url, notice: t('activerecord.models.college').capitalize+' '+t('deleted.f')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_college
      @college = College.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def college_params
      params.require(:college).permit(:institution_id, :area, :classrooms, :otherrooms, :sportscourts, :foodplaces, :libraries, :gradcertificatecourses, :previousyeargradcertcompletions)
    end
end
