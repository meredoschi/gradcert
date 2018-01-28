class SchoolnamesController < ApplicationController
  before_action :set_schoolname, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /schoolnames
  def index
    @schoolnames = Schoolname.all

		@title=t('list')+' '+t('activerecord.models.schoolname').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.schoolname').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.schoolname').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('schoolname').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Schoolname.accessible_by(current_ability).ransack(params[:q])
  	@schoolnames=@search.result.page(params[:page]).per(10)
		@numschoolnames=Schoolname.count

  end

  # GET /schoolnames/1
  def show
  	@title=t('activerecord.models.schoolname').capitalize   
 
#  	if !@schoolname.name.nil?
    
#    	@title=@title+": "+@schoolname.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.schoolname').capitalize+": "+@schoolname.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.schoolname').capitalize
  			
			else
					
				@title=tm('schoolname').pluralize.upcase

				if !@schoolname.name.nil? 
				
					@title+=" : "+@schoolname.name
				
				end	
				
			end
			
		end

  end

  # GET /schoolnames/new
  def new
    @schoolname = Schoolname.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.schoolname')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.schoolname')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.schoolname')  			
			
			end

		end
    
  end

  # GET /schoolnames/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.schoolname')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.schoolname')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.schoolname')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('schoolname').pluralize

			end
  	
  	end

  end

  # POST /schoolnames
  def create
    @schoolname = Schoolname.new(schoolname_params)

    if @schoolname.save
      redirect_to @schoolname, notice: t('activerecord.models.schoolname').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /schoolnames/1
  def update
    if @schoolname.update(schoolname_params)
     # redirect_to @schoolname, notice: 'Schoolname was successfully updated.'
       redirect_to @schoolname, notice: t('activerecord.models.schoolname').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /schoolnames/1
  def destroy
    @schoolname.destroy
    redirect_to schoolnames_url, notice: t('activerecord.models.schoolname').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schoolname
      @schoolname = Schoolname.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def schoolname_params
      params.require(:schoolname).permit(:name, :previousname, :active)
    end
end
