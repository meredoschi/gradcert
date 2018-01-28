class ProgramsController < ApplicationController
  before_action :set_program, only: %i[show edit update destroy]

  before_action :set_max_duration

  before_filter :authenticate_user!

  # Marcelo - CanCan
  load_and_authorize_resource

  # GET /programs
  # GET /programs.json

  def index
    if is_regular_user(current_user)

    else

      @title = t('course').pluralize.upcase + ' | ' + t('activerecord.models.program').pluralize.capitalize

    end

    # https://github.com/ryanb/cancan/wiki/Fetching-Records

    @all_programs = Program.includes(:programname).includes(:accreditation).includes(:institution).includes(:schoolterm).accessible_by(current_ability)
    @modern_programs = @all_programs.modern
    @search = @modern_programs.ransack(params[:q])
    @programs = @search.result.page(params[:page]).per(10)
    @numprograms = @modern_programs.count
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    @all_registrations = Registration.joins(student: :contact).joins(:accreditation)
    @registered_students = @all_registrations.on_program(@program)

    # 		@schoolyear_registrations=?

    if is_regular_user(current_user)

      @title = t('my.f').upcase + ' ' + t('course').upcase + ' | ' + tm('program').capitalize + ' | ' + t('actions.show')

    else

      @title = t('course').pluralize.upcase + ' | ' + tm('program').capitalize + ' | ' + t('actions.show')

      end

    #	if !@program.versions.last.nil?

    #		@whodid=@program.versions.last.whodunnit
    # 	  @user=User.where(id: @whodid).first
    #	  @contact=Contact.where(user_id: @whodid).first

    # 	end

    unless @program.versions.last.nil? # it could have been seeded in which case we must test for nil

      @userid = @program.versions.last.whodunnit

      @user = (User.where(id: @userid).first unless @userid.nil?)

    end
  end

  # GET /programs/new
  def new
    if is_admin_or_manager(current_user)

      @title = t('course').pluralize.upcase + ' | ' + tm('program').pluralize.capitalize + ' | ' + t('actions.new.m')

    else

      @title = t('my.f').upcase + ' ' + t('course').upcase + ' | ' + tm('program').capitalize + ' | ' + t('actions.new.m')

    end

    # 		profile = case

    # 	        when is_pap_staff(current_user) then @maxduration=Settings.longest_program_duration.pap
    # 	        when is_medres_staff(current_user) then @maxduration=Settings.longest_program_duration.medres

    # 				else
    # 				@maxduration=Settings.longest_program_duration.all

    # 	end

    @program = Program.new(duration: @maxduration)

    @program.build_address

    @program.build_admission(program_id: @program.id)

    # 	      	@program.build_address(streetname: current_user.institution.address.streetname, addr: current_user.institution.address.addr, complement: current_user.institution.address.complement, neighborhood: current_user.institution.address.neighborhood, municipality: current_user.institution.address.municipality, postalcode: current_user.institution.address.postalcode, country_id: current_user.institution.address.country_id)

    # 	 	@program.schoolyears.build

    for i in 1..@maxduration
      @program.schoolyears.build(programyear: i, grantsrequested: 0, grants: 0, scholarships: 0, maxenrollment: 0, theory: 0, practice: 0)
    end

    @program.build_accreditation

    @program.pap = true if is_pap_manager(current_user)

    @program.medres = true if is_medres_manager(current_user)
  end

  # GET /programs/1/edit
  def edit
    if is_regular_user(current_user)

      @title = t('my.f').upcase + ' ' + t('course').upcase + ' | ' + tm('program').capitalize + ' | ' + t('actions.edit')

    else

      @title = t('course').pluralize.upcase + ' | ' + tm('program').capitalize + ' | ' + t('actions.edit')

    end
  end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    unless is_admin_or_manager(current_user)
      @program.institution_id = current_user.institution_id
    end

    def permission_for(user)
      user.permission.kind
       end

    profile = if permission_for(current_user) == 'medresmgr' then @program.medres = true
              elsif permission_for(current_user) == 'papmgr' then @program.pap = true
      # 	when current_user.papmgr? then @program.pap=true
    end

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: t('activerecord.models.program').capitalize + ' ' + t('created.m') + ' ' + t('succesfully') }
        format.json { render action: 'show', status: :created, location: @program }
      else
        format.html { render action: 'new' }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: t('activerecord.models.program').capitalize + ' ' + t('updated.m') + ' ' + t('succesfully') }

        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program
    @program = Program.find(params[:id])
  end

  def set_max_duration

    @maxduration=2 # quickfix ! - Marcelo December 2017
#    profile = if is_pap_staff(current_user) then @maxduration = Settings.longest_program_duration.pap
#              elsif is_medres_staff(current_user) then @maxduration = Settings.longest_program_duration.medres

#              else
#                @maxduration = Settings.longest_program_duration.all

#    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def program_params
    params.require(:program).permit(:schoolterm_id, :professionalspecialty_id, :internal, :institution_id, :programname_id, :admission_id, :duration, :comment, :approved, :pap, :medres, :active, :schoolyear_id, schoolyears_attributes: %i[id done programyear grants maxenrollment theory practice scholarships candidates approved grantsrequested convokedtoregister _destroy registeredstudents], assignments_attributes: %i[program_id supervisor_id start_date main], address_attributes: %i[id header municipality_id streetname_id country_id postalcode addr streetnum complement neighborhood institution_id contact_id _destroy internal], accreditation_attributes: %i[id renewed start comment institution_id renewal suspension original suspended revocation revoked], admission_attributes: %i[id start finish candidates absentfirstexam absentfinalexam passedfirstexam appealsdeniedfirstexam appealsgrantedfirstexam appealsdeniedfinalexam appealsgrantedfinalexam admitted convoked program_id grantsasked grantsgiven accreditedgrants])
  end
end
