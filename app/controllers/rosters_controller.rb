class RostersController < ApplicationController
  before_action :set_roster, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /rosters
  def index
    @rosters = Roster.all

		@title=t('list')+' '+t('activerecord.models.roster').pluralize

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.roster').capitalize.pluralize   
    
    else

			if is_local_admin(current_user)
						
				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.roster').capitalize.pluralize   

  		else
 
  			@title=t('my.mp').upcase+' '+tm('roster').pluralize.upcase
    		
  		end
  		  
    end
       

  	@search = Roster.accessible_by(current_ability).ransack(params[:q])
  	@rosters=@search.result.page(params[:page]).per(10)
		@numrosters=Roster.count

  end

  # GET /rosters/1
  def show
  	@title=t('activerecord.models.roster').capitalize   
 
#  	if !@roster.name.nil?
    
#    	@title=@title+": "+@roster.name
    
#     end

  	if is_admin_or_manager(current_user)    

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.roster').capitalize+": "+@roster.name
			    			    
    else

 	 		if is_local_admin(current_user)    

				@title=t('navbar_menu_name').to_s.upcase+' | '+t('activerecord.models.roster').capitalize
  			
			else
					
				@title=tm('roster').pluralize.upcase

				if !@roster.name.nil? 
				
					@title+=" : "+@roster.name
				
				end	
				
			end
			
		end

  end

  # GET /rosters/new
  def new
    @roster = Roster.new

    if is_admin_or_manager(current_user)
    
			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.roster')
		
		else

			if is_local_admin(current_user) 

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.roster')  

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.roster')  			
			
			end

		end
    
  end

  # GET /rosters/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.roster')

    if is_admin_or_manager(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.roster')

    	else

			if is_local_admin(current_user) 

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.roster')

			else
			 			
 			  @title=t('noun.edit')+' '+tm('roster').pluralize

			end
  	
  	end

  end

  # POST /rosters
  def create
    @roster = Roster.new(roster_params)

    if @roster.save
      redirect_to @roster, notice: t('activerecord.models.roster').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /rosters/1
  def update
    if @roster.update(roster_params)
     # redirect_to @roster, notice: 'Roster was successfully updated.'
       redirect_to @roster, notice: t('activerecord.models.roster').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /rosters/1
  def destroy
    @roster.destroy
    redirect_to rosters_url, notice: t('activerecord.models.roster').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roster
      @roster = Roster.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def roster_params
      params.require(:roster).permit(:institution_id, :schoolterm_id, :authorizedsupervisors, :dataentrystart, :dataentryfinish)
    end
end
