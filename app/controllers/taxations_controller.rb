class TaxationsController < ApplicationController
  before_action :set_taxation, only: [:show, :edit, :update, :destroy]

  before_action :set_number_of_brackets

	before_filter :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /taxations
  def index
    @taxations = Taxation.all

		@title=t('list')+' '+t('activerecord.models.taxation').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.taxation').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.taxation').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('taxation').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Taxation.accessible_by(current_ability).ransack(params[:q])
  	@taxations=@search.result.page(params[:page]).per(10)
		@numtaxations=Taxation.count

  end

  # GET /taxations/1
  def show
  	@title=t('activerecord.models.taxation').capitalize   
 
#  	if !@taxation.name.nil?
    
#    	@title=@title+": "+@taxation.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.taxation').capitalize+": "+@taxation.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.taxation').capitalize
  			
			else
					
				@title=tm('taxation').pluralize.upcase

				if !@taxation.name.nil? 
				
					@title+=" : "+@taxation.name
				
				end	
				
			end
			
		end

  end

  # GET /taxations/new
  def new
    @taxation = Taxation.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.taxation')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.taxation')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.taxation')  			
			
			end

		end
    
    for i in 1..@num_brackets
	    @taxation.brackets.build(num: i)
		end

  end

  # GET /taxations/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.taxation')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.taxation')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.taxation')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('taxation').pluralize

			end
  	
  	end

  end

  # POST /taxations
  def create
    @taxation = Taxation.new(taxation_params)

		set_sector

    if @taxation.save
      redirect_to @taxation, notice: t('activerecord.models.taxation').capitalize+' '+t('created.f')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /taxations/1
  def update
    if @taxation.update(taxation_params)
     # redirect_to @taxation, notice: 'Taxation was successfully updated.'
       redirect_to @taxation, notice: t('activerecord.models.taxation').capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /taxations/1
  def destroy
    @taxation.destroy
    redirect_to taxations_url, notice: t('activerecord.models.taxation').capitalize+' '+t('deleted.f')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.

		# Applies to managers only
    def set_sector

			if is_pap_manager(current_user)	
				
				@taxation.pap=true
				
			end

			if is_medres_manager(current_user)	
				
				@taxation.medres=true
				
			end    

    end


    def set_number_of_brackets

  	  @num_brackets=Settings.max_tax_brackets

  	end	 				

    def set_taxation
      @taxation = Taxation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def taxation_params
        params.require(:taxation).permit(:name, :start, :finish, :socialsecurity, :pap, :medres, :bracket_id, brackets_attributes: [:id, :num, :start, :finish, :rate, :unlimited, :deductible, :_destroy])
#       params.require(:taxation).permit(:socialsecurity, :bracket_id)

    end
end
