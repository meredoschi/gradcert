class ResearchcentersController < ApplicationController
  before_action :set_researchcenter, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /researchcenters
  def index
    @researchcenters = Researchcenter.all

  	if is_admin_or_manager(current_user)    

			@title=t('entity').mb_chars.pluralize.upcase+' | '+t('activerecord.models.researchcenter').pluralize.capitalize
    
    else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+t('activerecord.models.researchcenter').capitalize
    
    end
     
  	@search = Researchcenter.accessible_by(current_ability).ransack(params[:q])
  	@researchcenters=@search.result.page(params[:page]).per(10)
		@numresearchcenters=Researchcenter.count

  end

  # GET /researchcenters/1
  def show
  	
		if is_admin_or_manager(current_user)
		
			@title=t('entity').mb_chars.pluralize.upcase+' | '+t('activerecord.models.researchcenter').capitalize.pluralize+' | '+t('actions.show')
		
		else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+t('activerecord.models.researchcenter').capitalize+' | '+t('actions.show')

		end
		 
  end

  # GET /researchcenters/new
  def new
    @researchcenter = Researchcenter.new
    
    if is_admin_or_manager(current_user)
  	 	
	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+tm('researchcenter').pluralize.capitalize+' | '+t('actions.new.m')  

		else

			 @title=t('my.f').upcase+" "+t('entity').mb_chars.upcase+' | '+tm('researchcenter').capitalize+' | '+t('actions.new.m')		 
		 
		end   

        
  end

  # GET /researchcenters/1/edit
  def edit

   	if is_admin_or_manager(current_user)    

     	 @title=t('entity').mb_chars.pluralize.upcase+' | '+t('noun.edit')+" "+t('activerecord.models.researchcenter')
    
    else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+t('activerecord.models.researchcenter').capitalize+' | '+t('actions.edit')
    
    end
    
  end

  # POST /researchcenters
  def create
    @researchcenter = Researchcenter.new(researchcenter_params)

    # treat for local admin
	 	if is_local_admin(current_user)    
      @researchcenter.institution_id=current_user.institution_id    
    end
    
    if @researchcenter.save
      redirect_to @researchcenter, notice: t('activerecord.models.researchcenter').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /researchcenters/1
  def update
    if @researchcenter.update(researchcenter_params)
     # redirect_to @researchcenter, notice: 'Researchcenter was successfully updated.'
       redirect_to @researchcenter, notice: t('activerecord.models.researchcenter').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /researchcenters/1
  def destroy
    @researchcenter.destroy
    redirect_to researchcenters_url, notice: t('activerecord.models.researchcenter').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_researchcenter
      @researchcenter = Researchcenter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def researchcenter_params
      params.require(:researchcenter).permit(:institution_id, :rooms, :labs, :intlprojectsdone, :ongoingintlprojects, :domesticprojectsdone, :ongoingdomesticprojects)
    end
end
