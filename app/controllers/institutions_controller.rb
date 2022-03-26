class InstitutionsController < ApplicationController
  before_action :set_institution, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user!

  # Marcelo - CanCan
	load_and_authorize_resource

  # GET /institutions
  # GET /institutions.json
  def index

    if is_admin_or_manager(current_user)

	    @title=t('entity').mb_chars.pluralize.upcase+' | '+t('institution_summary').pluralize.capitalize

		else

    	@title=t('my.f').mb_chars.upcase+" "+t('entity').mb_chars.upcase+' | '+t('summary').capitalize

		end

		# https://github.com/ryanb/cancan/wiki/Fetching-Records

  	@search = Institution.accessible_by(current_ability).ransack(params[:q])
  	@institutions=@search.result.page(params[:page]).per(10)
		@numinstitutions=Institution.count

  end

  # GET /institutions/1
  # GET /institutions/1.json

  def show

# To do: take a look at this.
#     @recent_programs=@institution.program.modern # Modern programs

	  @recent_programs=@institution.program

    @programs=@institution.program

		@num_institution_team_members

    @num_recent_programs=@recent_programs.count

# 		@institutionprograms=@institution.program.page(params[:page]).per(10)
# 		@institutionprograms=@recent_programs.page(params[:page]).per(10)

		@institutionprograms=@recent_programs.page(params[:page]).per(200)

    @num_institutionprograms=@institutionprograms.count

		@institution_managers=@institution.user.with_management_role
		@num_institution_managers=@institution_managers.count

		@institution_team_members=@institution.user.neither_student_nor_management
		@num_institution_team_members=@institution_team_members.count

		@institution_registrations=Registration.from_institution(@institution)
		@num_institution_registrations=@institution_registrations.count

  	 if is_admin_or_manager(current_user)

	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+t('institution_summary').pluralize.capitalize+' | '+t('actions.show')

	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+t('institution_summary').pluralize.capitalize+' | '+@institution.name

		 else

			 @title=t('my.f').mb_chars.upcase+" "+t('entity').mb_chars.upcase+' | '+t('summary').capitalize+' | '+@institution.name

		 end

		@papprograms=@institution.program.pap.page(params[:page]).per(10)
		@medresprograms=@institution.program.medicalresidency.page(params[:page]).per(10)

	# 	@occurrencetypes=['initial','renewal','revocation','suspension']

# 	 if @institution.provisional==false # starts having paper trail when data is checked as confirmed

			if !@institution.versions.last.nil?  # it could have been seeded in which case we must test for nil

	 			@userid=@institution.versions.last.whodunnit
	 			@userwho=User.where(id: @userid).first

			end
			# end
  end

  # GET /institutions/new
  def new
  # http://stackoverflow.com/questions/19235410/rails-4-strong-params-and-nested-form
    @institution = Institution.new

    @institution.build_phone

 	  @institution.build_address

 	  @institution.build_webinfo

 	  @institution.build_accreditation

  	 if is_admin_or_manager(current_user)

	   	 @title=t('entity').mb_chars.pluralize.upcase+' | '+t('institution_summary').pluralize.capitalize+' | '+t('actions.new.f')

		 else

			 @title=t('my.f').mb_chars.upcase+" "+t('entity')..mb_chars.upcase+' | '+t('summary').capitalize+' | '+t('actions.new.f')

		 end

  end

  # GET /institutions/1/edit
  def edit

    @institution = Institution.find(params[:id])

  	 if is_admin_or_manager(current_user)

  	   @title=t('entity').mb_chars.pluralize.upcase+' | '+t('institution_summary').pluralize.capitalize+' | '+t('actions.edit')

		 else

			 @title=t('my.f').mb_chars.upcase+" "+t('entity').mb_chars.upcase+' | '+t('summary').capitalize+' | '+t('actions.edit')

		 end

  end

  # POST /institutions
  # POST /institutions.json
  def create
    @institution = Institution.new(institution_params)

    respond_to do |format|
      if @institution.save
				format.html { redirect_to @institution, notice: t('activerecord.models.institution').capitalize+' '+t('created.f')+' '+t('succesfully') }
       #  format.html { redirect_to @institution, notice: 'atualizada com sucesso.'}
        format.json { render action: 'show', status: :created, location: @institution }
      else
        format.html { render action: 'new' }
        format.json { render json: @institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institutions/1
  # PATCH/PUT /institutions/1.json
  def update
    respond_to do |format|

			# ------------------------------------
      # 			@institution.user_id=current_user.id   # tracked updates before paper_trail
			# ------------------------------------

      if @institution.update(institution_params)
        format.html { redirect_to @institution, notice: t('activerecord.models.institution').capitalize+' '+t('updated.f')+' '+t('succesfully') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @institution.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /institutions/1
  # DELETE /institutions/1.json
  def destroy

#   		if !(@institution.pap || @institution.medicalresidency || !@institution.provisional)

  	case
   		when @institution.user.present? && @institution.user.count>0
			flash[:alert] = t('institution_removal_lock.withusers')
			redirect_to users_url
   		when @institution.program.count>0
					flash[:alert] = t('institution_removal_lock.withprograms')
					redirect_to programs_url
			when @institution.pap
	 			  flash[:alert] = t('institution_removal_lock.pap')
	 			  render 'edit'
 			when @institution.medres
					 flash[:alert] = t('institution_removal_lock.medicalresidency')
					 render 'edit'
			when !@institution.provisional
					flash[:alert] = t('institution_removal_lock.notprovisional')
					render 'edit'
			else
		    @institution.destroy
	  	  respond_to do |format|
	    	  format.html { redirect_to institutions_url }
	      	format.json { head :no_content }
	    	end
 		end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institution
      @institution = Institution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institution_params

    	 params.require(:institution).permit(:name, :abbreviation, :legacycode, :undergraduate, :url, :email, :institutiontype_id, :pap, :medres, :provisional, :user_id, :sector, address_attributes: [:id, :municipality_id, :streetname_id, :country_id, :internal, :postalcode, :addr, :complement, :neighborhood, :streetnum, :institution_id, :contact_id], phone_attributes: [:id, :main, :other, :mobile, :fax, :contact_id, :institution_id], webinfo_attributes: [:id, :site, :email, :facebook, :twitter, :other], accreditation_attributes: [:id, :renewed, :start, :comment, :institution_id, :renewal, :suspension, :original, :suspended, :revocation, :revoked])

    end
end
