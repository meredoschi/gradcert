class SchooltypesController < ApplicationController
  before_action :set_schooltype, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /schooltypes
  def index
    @schooltypes = Schooltype.all

		@title=t('list')+' '+t('activerecord.models.schooltype').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.schooltype').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.schooltype').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('schooltype').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Schooltype.accessible_by(current_ability).ransack(params[:q])
  	@schooltypes=@search.result.page(params[:page]).per(10)
		@numschooltypes=Schooltype.count

  end

  # GET /schooltypes/1
  def show
  	@title=t('activerecord.models.schooltype').capitalize   
 
#  	if !@schooltype.name.nil?
    
#    	@title=@title+": "+@schooltype.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.schooltype').capitalize+": "+@schooltype.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').to_s.upcase+' | '+t('activerecord.models.schooltype').capitalize
  			
			else
					
				@title=tm('schooltype').pluralize.upcase

				if !@schooltype.name.nil? 
				
					@title+=" : "+@schooltype.name
				
				end	
				
			end
			
		end

  end

  # GET /schooltypes/new
  def new
    @schooltype = Schooltype.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.schooltype')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.schooltype')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.schooltype')  			
			
			end

		end
    
  end

  # GET /schooltypes/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.schooltype')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.schooltype')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.schooltype')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('schooltype').pluralize

			end
  	
  	end

  end

  # POST /schooltypes
  def create
    @schooltype = Schooltype.new(schooltype_params)

    if @schooltype.save
      redirect_to @schooltype, notice: t('activerecord.models.schooltype').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /schooltypes/1
  def update
    if @schooltype.update(schooltype_params)
     # redirect_to @schooltype, notice: 'Schooltype was successfully updated.'
       redirect_to @schooltype, notice: t('activerecord.models.schooltype').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /schooltypes/1
  def destroy
    @schooltype.destroy
    redirect_to schooltypes_url, notice: t('activerecord.models.schooltype').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schooltype
      @schooltype = Schooltype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def schooltype_params
      params.require(:schooltype).permit(:name)
    end
end
