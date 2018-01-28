class ProfessionalfamiliesController < ApplicationController
  before_action :set_professionalfamily, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /professionalfamilies
  def index
    @professionalfamilies = Professionalfamily.all

		@title=t('list')+' '+t('activerecord.models.professionalfamily').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.professionalfamily').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.professionalfamily').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('professionalfamily').pluralize.upcase
    		
  		end
  		  
    end
       
  	@q = Professionalfamily.accessible_by(current_ability).ransack(params[:q])
		@professionalfamilies=@q.result.page(params[:page]).per(10)
		@numprofessionalfamilies=Professionalfamily.count

  end

  # GET /professionalfamilies/1
  def show
  	@title=t('activerecord.models.professionalfamily').capitalize   
 
 		@professions=@professionalfamily.profession.page(params[:page]).per(10)

#  	if !@professionalfamily.name.nil?
    
#    	@title=@title+": "+@professionalfamily.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.professionalfamily').capitalize+": "+@professionalfamily.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.professionalfamily').capitalize
  			
			else
					
				@title=tm('professionalfamily').pluralize.upcase

				if !@professionalfamily.name.nil? 
				
					@title+=" : "+@professionalfamily.name
				
				end	
				
			end
			
		end

  end

  # GET /professionalfamilies/new
  def new
    @professionalfamily = Professionalfamily.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.professionalfamily')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.professionalfamily')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.professionalfamily')  			
			
			end

		end
    
  end

  # GET /professionalfamilies/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.professionalfamily')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.professionalfamily')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.professionalfamily')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('professionalfamily').pluralize

			end
  	
  	end

  end

  # POST /professionalfamilies
  def create
    @professionalfamily = Professionalfamily.new(professionalfamily_params)

    if @professionalfamily.save
      redirect_to @professionalfamily, notice: t('activerecord.models.professionalfamily').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /professionalfamilies/1
  def update
    if @professionalfamily.update(professionalfamily_params)
     # redirect_to @professionalfamily, notice: 'Professionalfamily was successfully updated.'
       redirect_to @professionalfamily, notice: t('activerecord.models.professionalfamily').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /professionalfamilies/1
  def destroy
    @professionalfamily.destroy
    redirect_to professionalfamilies_url, notice: t('activerecord.models.professionalfamily').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professionalfamily
      @professionalfamily = Professionalfamily.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def professionalfamily_params
      params.require(:professionalfamily).permit(:name, :subgroup_id, :familycode, :pap, :medres)
    end
end
