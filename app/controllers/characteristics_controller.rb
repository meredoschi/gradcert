class CharacteristicsController < ApplicationController
  before_action :set_characteristic, only: [:show, :edit, :update, :destroy]

	before_filter :authenticate_user! # By default... Devise
 
	load_and_authorize_resource  # CanCan(Can)  

  # GET /characteristics
  def index
    @characteristics = Characteristic.all

   	if is_admin_or_manager(current_user)    

    @title=t('entity').mb_chars.pluralize.upcase+' | '+tm('characteristic').pluralize.titleize
    
    # @title="Debug!"
    
    else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+tm('characteristic').capitalize
    
    end
    	
    
  	@search = Characteristic.accessible_by(current_ability).ransack(params[:q])
  	@characteristics=@search.result.page(params[:page]).per(10)
		@numcharacteristics=Characteristic.count

  end

  # GET /characteristics/1
  def show

		 @numbeds=@characteristic.institution.healthcareinfo.pluck(:totalbeds).first

  	 if is_admin_or_manager(current_user)
  	 	
	  	 @title=t('entity').mb_chars.pluralize.upcase+' | '+tm('characteristic').pluralize.capitalize+' | '+t('actions.show')  

		 else

			 @title=t('my.f').mb_chars.upcase+" "+t('entity').mb_chars.upcase+' | '+tm('characteristic').capitalize+' | '+t('actions.show')		 
		 
		 end  


  end

  # GET /characteristics/new
  def new
    @characteristic = Characteristic.new

 	  @characteristic.build_funding

  	 if is_admin_or_manager(current_user)
  	 	
	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+tm('characteristic').mb_chars.pluralize.capitalize+' | '+t('actions.new.m')  

		 else

			 @title=t('my.f').mb_chars.upcase+" "+t('entity').mb_chars.upcase+' | '+tm('characteristic').mb_chars.capitalize+' | '+t('actions.new.m')		 
		 
		 end   
        
  end

  # GET /characteristics/1/edit
  def edit

   	if is_admin_or_manager(current_user)    

	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+tm('characteristic').pluralize.capitalize+' | '+t('actions.edit')  
    
    else

			 @title=t('my.f').upcase+" "+t('entity').mb_chars.upcase+' | '+tm('characteristic').capitalize+' | '+t('actions.edit')		 
    
    end

  end

  # POST /characteristics
  def create
    @characteristic = Characteristic.new(characteristic_params)

    # treat for local admin
	 	if is_local_admin(current_user)    
      @characteristic.institution_id=current_user.institution_id    
    end
	  
  
    if @characteristic.save
      redirect_to @characteristic, notice: t('activerecord.models.characteristic').capitalize+' '+t('created.m')+' '+t('succesfully') 
    else
      render :new
    end
  end

  # PATCH/PUT /characteristics/1
  def update
    if @characteristic.update(characteristic_params)
     # redirect_to @characteristic, notice: 'Characteristic was successfully updated.'
       redirect_to @characteristic, notice: t('activerecord.models.characteristic').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /characteristics/1
  def destroy
    @characteristic.destroy
    redirect_to characteristics_url, notice: t('activerecord.models.characteristic').capitalize+' '+t('deleted.m')+' '+t('succesfully')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_characteristic
      @characteristic = Characteristic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def characteristic_params
      params.require(:characteristic).permit(:institution_id, :mission, :corevalues, :userprofile, :stateregion_id, :relationwithpublichealthcare, :publicfundinglevel, :highlightareas, funding_attributes: [:id, :government, :agreements, :privatesector, :other, :ppp, :percentvalues, :comment]  )
    end
end