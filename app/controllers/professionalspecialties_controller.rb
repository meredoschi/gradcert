class ProfessionalspecialtiesController < ApplicationController
  before_action :set_professionalspecialty, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /professionalspecialties
  def index
    @professionalspecialties = Professionalspecialty

		@title=t('list')+' '+t('activerecord.models.professionalspecialty').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar.programming').upcase
      @title+=' | '+t('activerecord.models.professionalspecialty').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar.programming').upcase
        @title+=' | '+t('activerecord.models.professionalspecialty').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('professionalspecialty').pluralize.upcase
    		
  		end
  		  
    end
       
    @all_professional_specialties=Professionalspecialty.all

		@search = @all_professional_specialties.includes(:professionalarea).accessible_by(current_ability).ransack(params[:q])

  #	@search = @all_professional_specialties.accessible_by(current_ability).ransack(params[:q])

  	@professionalspecialties=@search.result.page(params[:page]).per(10)
		@numprofessionalspecialties=@all_professional_specialties.count

  end

  # GET /professionalspecialties/1
  def show
  	@title=t('activerecord.models.professionalspecialty').capitalize   
 
#  	if !@professionalspecialty.name.nil?
    
#    	@title=@title+": "+@professionalspecialty.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar.programming').upcase+" | "+t('activerecord.models.professionalspecialty').capitalize+": "+@professionalspecialty.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar.programming').mb_chars.upcase+' | '+t('activerecord.models.professionalspecialty').capitalize
  			
			else
					
				@title=tm('professionalspecialty').pluralize.upcase

				if !@professionalspecialty.name.nil? 
				
					@title+=" : "+@professionalspecialty.name
				
				end	
				
			end
			
		end

  end

  # GET /professionalspecialties/new
  def new
    @professionalspecialty = Professionalspecialty.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar.programming').upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.professionalspecialty')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.professionalspecialty')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.professionalspecialty')  			
			
			end

		end
    
  end

  # GET /professionalspecialties/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.professionalspecialty')

    if is_admin_or_manager(current_user) 

				@title=t('navbar.programming').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.professionalspecialty')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar.programming').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.professionalspecialty')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('professionalspecialty').pluralize

			end
  	
  	end

  end

  # POST /professionalspecialties
  def create
    @professionalspecialty = Professionalspecialty.new(professionalspecialty_params)

    if @professionalspecialty.save
      redirect_to @professionalspecialty, notice: t('activerecord.models.professionalspecialty').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /professionalspecialties/1
  def update
    if @professionalspecialty.update(professionalspecialty_params)
     # redirect_to @professionalspecialty, notice: 'Professionalspecialty was successfully updated.'
       redirect_to @professionalspecialty, notice: t('activerecord.models.professionalspecialty').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /professionalspecialties/1
  def destroy
    @professionalspecialty.destroy
    redirect_to professionalspecialties_url, notice: t('activerecord.models.professionalspecialty').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professionalspecialty
      @professionalspecialty = Professionalspecialty.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def professionalspecialty_params
      params.require(:professionalspecialty).permit(:name, :previouscode, :previousname, :comment, :pap, :medres, :professionalarea_id, :legacy)
    end
end
