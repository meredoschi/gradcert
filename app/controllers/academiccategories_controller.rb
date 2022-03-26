class AcademiccategoriesController < ApplicationController
  before_action :set_academiccategory, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /academiccategories
  def index
    @academiccategories = Academiccategory.all

		@title=t('list')+' '+t('activerecord.models.academiccategory').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.academiccategory').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.academiccategory').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('academiccategory').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Academiccategory.accessible_by(current_ability).ransack(params[:q])
  	@academiccategories=@search.result.page(params[:page]).per(10)
		@numacademiccategories=Academiccategory.count

  end

  # GET /academiccategories/1
  def show
  	@title=t('activerecord.models.academiccategory').capitalize   
 
#  	if !@academiccategory.name.nil?
    
#    	@title=@title+": "+@academiccategory.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.academiccategory').capitalize+": "+@academiccategory.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.academiccategory').capitalize
  			
			else
					
				@title=tm('academiccategory').pluralize.upcase

				if !@academiccategory.name.nil? 
				
					@title+=" : "+@academiccategory.name
				
				end	
				
			end
			
		end

  end

  # GET /academiccategories/new
  def new
    @academiccategory = Academiccategory.new

    
		@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.academiccategory')
		
    
  end

  # GET /academiccategories/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.academiccategory')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.academiccategory')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.academiccategory')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('academiccategory').pluralize

			end
  	
  	end

  end

  # POST /academiccategories
  def create
    @academiccategory = Academiccategory.new(academiccategory_params)

    if @academiccategory.save
      redirect_to @academiccategory, notice: t('activerecord.models.academiccategory').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /academiccategories/1
  def update
    if @academiccategory.update(academiccategory_params)
     # redirect_to @academiccategory, notice: 'Academiccategory was successfully updated.'
       redirect_to @academiccategory, notice: t('activerecord.models.academiccategory').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /academiccategories/1
  def destroy
    @academiccategory.destroy
    redirect_to academiccategories_url, notice: t('activerecord.models.academiccategory').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_academiccategory
      @academiccategory = Academiccategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def academiccategory_params
      params.require(:academiccategory).permit(:name)
    end
end
