class RegionalofficesController < ApplicationController
  before_action :set_regionaloffice, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /regionaloffices
  def index
    @regionaloffices = Regionaloffice.all

		@title=t('list')+' '+t('activerecord.models.regionaloffice').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('definition').pluralize.to_s.upcase
      @title+=' | '+t('activerecord.models.regionaloffice').capitalize.pluralize   
      		  
    end
       

  	@search = Regionaloffice.accessible_by(current_ability).ransack(params[:q])
  	@regionaloffices=@search.result.page(params[:page]).per(10)
		@numregionaloffices=Regionaloffice.count

  end

  # GET /regionaloffices/1
  def show
  
    @regionalofficemunicipalities=@regionaloffice.municipality.page(params[:page]).per(10)
 
   	@title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.regionaloffice').capitalize+" | "+t('actions.show')

  end

  # GET /regionaloffices/new
  def new
    @regionaloffice = Regionaloffice.new

		@regionaloffice.build_phone
		
 	  @regionaloffice.build_address 

 	  @regionaloffice.build_webinfo 
 	  
    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.regionaloffice')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.regionaloffice')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.regionaloffice')  			
			
			end

		end
    
  end

  # GET /regionaloffices/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.regionaloffice')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.regionaloffice')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.regionaloffice')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('regionaloffice').pluralize

			end
  	
  	end

  end

  # POST /regionaloffices
  def create
    @regionaloffice = Regionaloffice.new(regionaloffice_params)

    if @regionaloffice.save
      redirect_to @regionaloffice, notice: t('activerecord.models.regionaloffice').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /regionaloffices/1
  def update
    if @regionaloffice.update(regionaloffice_params)
     # redirect_to @regionaloffice, notice: 'Regionaloffice was successfully updated.'
       redirect_to @regionaloffice, notice: t('activerecord.models.regionaloffice').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /regionaloffices/1
  def destroy
    @regionaloffice.destroy
    redirect_to regionaloffices_url, notice: t('activerecord.models.regionaloffice').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_regionaloffice
      @regionaloffice = Regionaloffice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def regionaloffice_params
      params.require(:regionaloffice).permit(:name, :num, :directorsname, address_attributes: [:id, :municipality_id, :streetname_id, :country_id, :postalcode, :addr, :complement, :neighborhood, :gift_id, :institution_id, :contact_id], phone_attributes: [:id, :main, :other, :mobile, :contact_id, :institution_id], webinfo_attributes: [:id, :site, :email, :facebook, :twitter, :other])
    end
end
