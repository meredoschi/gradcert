class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /schools
  def index
    @schools = School.all

		@title=t('list')+' '+t('activerecord.models.school').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.school').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.school').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('school').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = School.accessible_by(current_ability).ransack(params[:q])
  	@schools=@search.result.page(params[:page]).per(10)
		@numschools=School.count

  end

  # GET /schools/1
  def show
  	@title=t('activerecord.models.school').capitalize   
 
#  	if !@school.name.nil?
    
#    	@title=@title+": "+@school.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.school').capitalize+": "+@school.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.school').capitalize
  			
			else
					
				@title=tm('school').pluralize.upcase

				if !@school.name.nil? 
				
					@title+=" : "+@school.name
				
				end	
				
			end
			
		end

  end

  # GET /schools/new
  def new
    @school = School.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.school')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.school')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.school')  			
			
			end

		end
    
  end

  # GET /schools/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.school')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.school')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.school')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('school').pluralize

			end
  	
  	end

  end

  # POST /schools
  def create
    @school = School.new(school_params)

    if @school.save
      redirect_to @school, notice: t('activerecord.models.school').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /schools/1
  def update
    if @school.update(school_params)
     # redirect_to @school, notice: 'School was successfully updated.'
       redirect_to @school, notice: t('activerecord.models.school').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /schools/1
  def destroy
    @school.destroy
    redirect_to schools_url, notice: t('activerecord.models.school').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def school_params
      params.require(:school).permit(:name, :abbreviation, :ministrycode, :academiccategory_id, :public)
    end
end
