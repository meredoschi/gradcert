class CoursenamesController < ApplicationController
  before_action :set_coursename, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /coursenames
  def index
    @coursenames = Coursename.all

		@title=t('list')+' '+t('activerecord.models.coursename').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.coursename').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.coursename').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('coursename').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Coursename.accessible_by(current_ability).ransack(params[:q])
  	@coursenames=@search.result.page(params[:page]).per(10)
		@numcoursenames=Coursename.count

  end

  # GET /coursenames/1
  def show
  	@title=t('activerecord.models.coursename').capitalize   
 
#  	if !@coursename.name.nil?
    
#    	@title=@title+": "+@coursename.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.coursename').capitalize+": "+@coursename.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').to_s.upcase+' | '+t('activerecord.models.coursename').capitalize
  			
			else
					
				@title=tm('coursename').pluralize.upcase

				if !@coursename.name.nil? 
				
					@title+=" : "+@coursename.name
				
				end	
				
			end
			
		end

  end

  # GET /coursenames/new
  def new
  
	  @title=t('definition').pluralize.to_s.upcase+" | "+t('activerecord.models.degreetype').capitalize+" | "+t('actions.new.m')
    @degreetype = Degreetype.new
  
  end

  # GET /coursenames/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.coursename')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.coursename')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.coursename')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('coursename').pluralize

			end
  	
  	end

  end

  # POST /coursenames
  def create
    @coursename = Coursename.new(coursename_params)

    if @coursename.save
      redirect_to @coursename, notice: t('activerecord.models.coursename').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /coursenames/1
  def update
    if @coursename.update(coursename_params)
     # redirect_to @coursename, notice: 'Coursename was successfully updated.'
       redirect_to @coursename, notice: t('activerecord.models.coursename').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /coursenames/1
  def destroy
    @coursename.destroy
    redirect_to coursenames_url, notice: t('activerecord.models.coursename').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coursename
      @coursename = Coursename.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def coursename_params
      params.require(:coursename).permit(:name, :previousname, :active, :legacycode)
    end
end
