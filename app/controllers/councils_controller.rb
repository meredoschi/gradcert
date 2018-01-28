class CouncilsController < ApplicationController
  before_action :set_council, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /councils
  def index
    @councils = Council.all

		@title=t('list')+' '+t('activerecord.models.council').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('definition').mb_chars.pluralize.upcase
      @title+=' | '+t('activerecord.models.council').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('definition').mb_chars.pluralize.upcase
        @title+=' | '+t('activerecord.models.council').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('council').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Council.accessible_by(current_ability).ransack(params[:q])
  	@councils=@search.result.page(params[:page]).per(10)
		@numcouncils=Council.count

  end

  # GET /councils/1
  def show
  	@title=t('activerecord.models.council').capitalize   
 
#  	if !@council.name.nil?
    
#    	@title=@title+": "+@council.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('definition').mb_chars.pluralize.upcase+" | "+t('activerecord.models.council').capitalize+": "+@council.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('definition').mb_chars.upcase+' | '+t('activerecord.models.council').capitalize
  			
			else
					
				@title=tm('council').pluralize.upcase

				if !@council.name.nil? 
				
					@title+=" : "+@council.name
				
				end	
				
			end
			
		end

  end

  # GET /councils/new
  def new
    @council = Council.new

    @council.build_phone
		
 	  @council.build_address 

 	  @council.build_webinfo 
 	  
# 	  @council.
    

    if is_admin_or_manager(current_user)
    
			@title=t('definition').mb_chars.pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.council')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.council')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.council')  			
			
			end

		end
    
		
  end

  # GET /councils/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.council')

    if is_admin_or_manager(current_user) 

				@title=t('definition').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.council')

    	else

			if is_local_admin(current_user) 

				@title=t('definition').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.council')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('council').pluralize

			end
  	
  	end

  end

  # POST /councils
  def create
  
    @council = Council.new(council_params)

    if @council.save
      redirect_to @council, notice: t('activerecord.models.council').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /councils/1
  def update
    if @council.update(council_params)
     # redirect_to @council, notice: 'Council was successfully updated.'
       redirect_to @council, notice: t('activerecord.models.council').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /councils/1
  def destroy
    @council.destroy
    redirect_to councils_url, notice: t('activerecord.models.council').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_council
      @council = Council.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def council_params
      params.require(:council).permit(:name, :address_id, :phone_id, :webinfo_id, :state_id, :abbreviation, professionalfamily_attributes: [:id, :name, :subgroup_id, :familycode, :pap, :medres, :_destroy],   address_attributes: [:id, :municipality_id, :streetname_id, :streetnum, :country_id, :internal, :postalcode, :addr, :complement, :neighborhood, :council_id], phone_attributes: [:id, :main, :other, :mobile, :fax, :contact_id, :council_id], webinfo_attributes: [:id, :site, :email, :facebook, :twitter, :other, :council_id])
    end
end
