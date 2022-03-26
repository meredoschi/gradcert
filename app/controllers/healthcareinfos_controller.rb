class HealthcareinfosController < ApplicationController
  before_action :set_healthcareinfo, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user!

 # Marcelo - CanCan
	load_and_authorize_resource 

  # GET /healthcareinfos
  # GET /healthcareinfos.json
  def index

  	if is_admin_or_manager(current_user)    

			@title=t('entity').mb_chars.pluralize.upcase+' | '+t('activerecord.models.healthcareinfo').pluralize.capitalize
    
    else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+tm('healthcareinfo').capitalize
    
    end

	  @search = Healthcareinfo.accessible_by(current_ability).ransack(params[:q])
  	@healthcareinfos=@search.result.page(params[:page]).per(10)
    @numhealthcareinfos=Healthcareinfo.accessible_by(current_ability).count
    
  end

  # GET /healthcareinfos/1
  # GET /healthcareinfos/1.json
  def show

		if is_admin_or_manager(current_user)
		
			@title=t('entity').mb_chars.pluralize.upcase+' | '+tm('healthcareinfo').capitalize+' | '+t('actions.show')
		
		else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+tm('healthcareinfo').capitalize+' | '+t('actions.show')

		end
		   	  	
  end

  # GET /healthcareinfos/new
  def new
    @healthcareinfo = Healthcareinfo.new
    
    if is_admin_or_manager(current_user)
  	 	
	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+tm('healthcareinfo').pluralize.capitalize+' | '+t('actions.new.f')  

		else

			 @title=t('my.f').upcase+" "+t('entity').mb_chars.upcase+' | '+tm('healthcareinfo').capitalize+' | '+t('actions.new.f')		 
		 
		end   

  end

  # GET /healthcareinfos/1/edit
  def edit

		if is_admin_or_manager(current_user)
		
			@title=t('entity').mb_chars.pluralize.upcase+' | '+tm('healthcareinfo').capitalize+' | '+t('actions.edit')
		
		else

			@title=t('my.f').upcase+' '+t('entity').mb_chars.upcase+' | '+tm('healthcareinfo').capitalize+' | '+t('actions.edit')

		end

  end

  # POST /healthcareinfos
  # POST /healthcareinfos.json
  def create
    @healthcareinfo = Healthcareinfo.new(healthcareinfo_params)

    # treat for local admin
	 	if is_local_admin(current_user)    
      @healthcareinfo.institution_id=current_user.institution_id    
    end

    respond_to do |format|
      if @healthcareinfo.save
      	format.html { redirect_to @healthcareinfo, notice: t('activerecord.models.healthcareinfo').capitalize+' '+t('created.f')+' '+t('succesfully') }        
        format.json { render action: 'show', status: :created, location: @healthcareinfo }
      else
        format.html { render action: 'new' }
        format.json { render json: @healthcareinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /healthcareinfos/1
  # PATCH/PUT /healthcareinfos/1.json
  def update
    respond_to do |format|
      if @healthcareinfo.update(healthcareinfo_params)
        format.html { redirect_to @healthcareinfo, notice: t('activerecord.models.healthcareinfo').capitalize+' '+t('updated.f')+' '+t('succesfully') }
 
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @healthcareinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /healthcareinfos/1
  # DELETE /healthcareinfos/1.json
  def destroy
    @healthcareinfo.destroy
    respond_to do |format|
      format.html { redirect_to healthcareinfos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_healthcareinfo
      @healthcareinfo = Healthcareinfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def healthcareinfo_params
      params.require(:healthcareinfo).permit(:institution_id, :totalbeds, :icubeds, :ambulatoryrooms, :labs, :emergencyroombeds, :equipmenthighlights, :consultations, :admissions, :radiologyprocedures, :labexams, :surgeries)
    end
end
