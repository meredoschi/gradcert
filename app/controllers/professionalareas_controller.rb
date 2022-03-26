class ProfessionalareasController < ApplicationController
  before_action :set_professionalarea, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /professionalareas
  def index
    @professionalareas = Professionalarea.all

		@title=t('list')+' '+t('activerecord.models.professionalarea').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar.programming').mb_chars.pluralize.upcase
      @title+=' | '+t('activerecord.models.professionalarea').mb_chars.capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar.programming').mb_chars.pluralize.upcase
        @title+=' | '+t('activerecord.models.professionalarea').mb_chars.capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('professionalarea').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Professionalarea.accessible_by(current_ability).ransack(params[:q])
  	@professionalareas=@search.result.page(params[:page]).per(10)
		@numprofessionalareas=Professionalarea.count

  end

  # GET /professionalareas/1
  def show
#   	@title=t('activerecord.models.professionalarea').mb_chars.capitalize   
  	
		@professionalspecialties=Professionalspecialty.all

		@area_specialties=@professionalspecialties.for_area(@professionalarea)
		
		@num_area_specialties=@area_specialties.count
		 
#  	if !@professionalarea.name.nil?
    
#    	@title=@title+": "+@professionalarea.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar.programming').mb_chars.pluralize.upcase+" | "+t('activerecord.models.professionalarea').mb_chars.capitalize+": "+@professionalarea.name.downcase
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar.programming').mb_chars.mb_chars.upcase+' | '+t('activerecord.models.professionalarea').mb_chars.capitalize
  			
			else
					
				@title=tm('professionalarea').pluralize.upcase

				if !@professionalarea.name.nil? 
				
					@title+=" : "+@professionalarea.name
				
				end	
				
			end
			
		end

  end

  # GET /professionalareas/new
  def new
    @professionalarea = Professionalarea.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar.programming').mb_chars.pluralize.upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.professionalarea')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.professionalarea')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.professionalarea')  			
			
			end

		end
    
  end

  # GET /professionalareas/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.professionalarea')

    if is_admin_or_manager(current_user) 

				@title=t('navbar.programming').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.professionalarea')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar.programming').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.professionalarea')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('professionalarea').pluralize

			end
  	
  	end

  end

  # POST /professionalareas
  def create
    @professionalarea = Professionalarea.new(professionalarea_params)

    if @professionalarea.save
      redirect_to @professionalarea, notice: t('activerecord.models.professionalarea').mb_chars.capitalize+' '+t('created.f')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /professionalareas/1
  def update
    if @professionalarea.update(professionalarea_params)
     # redirect_to @professionalarea, notice: 'Professionalarea was successfully updated.'
       redirect_to @professionalarea, notice: t('activerecord.models.professionalarea').mb_chars.capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /professionalareas/1
  def destroy
    @professionalarea.destroy
    redirect_to professionalareas_url, notice: t('activerecord.models.professionalarea').mb_chars.capitalize+' '+t('deleted.f')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professionalarea
      @professionalarea = Professionalarea.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def professionalarea_params
      params.require(:professionalarea).permit(:name, :previouscode, :previousname, :comment, :pap, :medres, :legacy)
    end
end
