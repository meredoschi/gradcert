class PlacesavailablesController < ApplicationController
  before_action :set_placesavailable, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /placesavailables
  def index

    @registrations_accessible=Registration.accessible_by(current_ability)

    @placesavailables = Placesavailable.accessible_by(current_ability)

    @schoolterms=Schoolterm.accessible_by(current_ability)

    @scholarships_authorized=@placesavailables.authorized_for_schoolterm(@schoolterms.latest)
    @scholarships_offered=@schoolterms.latest.scholarshipsoffered

    @scholarships_authorized=@placesavailables.authorized_for_schoolterm(@schoolterms.latest)
    @scholarships_offered=@schoolterms.latest.scholarshipsoffered

    calculate_enrollment


    calculate_veterans

    @num_still_available=@authorized_for_latest_term-@num_new_registrations_active

    @num_active=@num_new_registrations_active # i.e. first_year active

    @num_total_active=@num_active+@num_veterans_active

		@title=t('list')+' '+t('activerecord.models.placesavailable').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase
      @title+=' | '+t('activerecord.models.placesavailable').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar_menu_name').pluralize.upcase
        @title+=' | '+t('activerecord.models.placesavailable').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('placesavailable').pluralize.upcase

  		end

      if is_admin_or_manager(current_user)

        @enrolled_at_institution=Registration.from_institution(placesavailable.institution).on_schoolterm(placesavailable.schoolterm)

      else

        @enrolled_at_institution=@registrations_accessible.on_schoolterm(Schoolterm.latest) # To do: make this more generic as above

      end
      @institution_enrollment=@enrolled_at_institution.count

      @scholarships_offered=Schoolterm.latest.scholarshipsoffered # For the future - to do: differentiate between Pap and Medres place if here.

      @authorized_for_latest_term=@placesavailables.authorized_for_latest_term

    end


  	@search = @placesavailables.accessible_by(current_ability).ransack(params[:q])
    @search = @placesavailables.ransack(params[:q])

  	@placesavailables=@search.result.page(params[:page]).per(50)
		@numplacesavailables=@placesavailables.count

  end

  # GET /placesavailables/1
  def show
  	@title=t('activerecord.models.placesavailable').capitalize

#  	if !@placesavailable.name.nil?

#    	@title=@title+": "+@placesavailable.name

#     end

    calculate_enrollment

    inst=@placesavailable.institution

    term_start=@placesavailable.schoolterm.start

    @contextual_registrations=@registrations.from_institution(inst).contextual_on(term_start)

    @active_registrations=@contextual_registrations.confirmed.active

    @num_active_registrations=@active_registrations.count



#    @contextual_registrations=Registration.from_institution(inst).contextual_on(term_start)


  	if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('activerecord.models.placesavailable').capitalize+": "+@placesavailable.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.placesavailable').capitalize

			else

				@title=tm('placesavailable').pluralize.upcase

				if !@placesavailable.name.nil?

					@title+=" : "+@placesavailable.name

				end

			end

		end

  end

  # GET /placesavailables/new
  def new
    @placesavailable = Placesavailable.new

    if is_admin_or_manager(current_user)

			@title=t('navbar_menu_name').pluralize.upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.placesavailable')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.placesavailable')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.placesavailable')

			end

		end

  end

  # GET /placesavailables/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.placesavailable')

    if is_admin_or_manager(current_user)

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.placesavailable')

    	else

			if is_local_admin(current_user)

				@title=t('navbar_menu_name').pluralize.upcase+' | '+t('noun.edit')+' '+t('activerecord.models.placesavailable')

			else

 			  @title=t('noun.edit')+' '+tm('placesavailable').pluralize

			end

  	end

  end

  # POST /placesavailables
  def create
    @placesavailable = Placesavailable.new(placesavailable_params)

    if @placesavailable.save
      redirect_to @placesavailable, notice: t('activerecord.models.placesavailable').capitalize+' '+t('created.m')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /placesavailables/1
  def update
    if @placesavailable.update(placesavailable_params)
     # redirect_to @placesavailable, notice: 'Placesavailable was successfully updated.'
       redirect_to @placesavailable, notice: t('activerecord.models.placesavailable').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /placesavailables/1
  def destroy
    @placesavailable.destroy
    redirect_to placesavailables_url, notice: t('activerecord.models.placesavailable').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placesavailable
      @placesavailable = Placesavailable.find(params[:id])
    end

    def calculate_enrollment

      @placesavailables = Placesavailable.accessible_by(current_ability)
      @schoolterms=Schoolterm.accessible_by(current_ability)
      @registrations=Registration.accessible_by(current_ability)

      @enrolled_at_institution=@registrations
      # byebug

      @institution_enrollment=@enrolled_at_institution.count
      @scholarships_offered=@schoolterms.latest.scholarshipsoffered # For the future - to do: differentiate between Pap and Medres place if here.

      @authorized_for_latest_term=@placesavailables.authorized_for_latest_term

    end

    def calculate_veterans

      @registrations=Registration.accessible_by(current_ability)

      @latest_term=@schoolterms.latest
  	  @previous_term=@latest_term.previous.first

  	  @latest_term_registrations=@registrations.on_schoolterm(@latest_term)
      @new_registrations_active=@latest_term_registrations.active
      @num_new_registrations_active=@new_registrations_active.count

    	@num_latest_term_registrations=@latest_term_registrations.count

  	  @previous_term_registrations=@registrations.on_schoolterm(@previous_term)
  	  @num_previous_term_registrations=@previous_term_registrations.count
      senior_year=2

  	  @previous_term_registrations_on_multiyear_programs=@previous_term_registrations.two_year_program.where("schoolyears.programyear < ?",senior_year) # Pap is at most 2

      @num_previous_term_registrations_on_multiyear_programs=@previous_term_registrations_on_multiyear_programs.count

      @subtotal=@scholarships_authorized+@num_previous_term_registrations_on_multiyear_programs

      @remaining_scholarships=@scholarships_offered-@subtotal

#      @veterans_registered=@registrations.contextual_on(@previous_term.start).veterans

      @veterans_registered=Registration.for_schoolterm(Schoolterm.latest.previous.first).veterans

      @num_veterans_registered=@veterans_registered.count

      @num_veterans_active=@veterans_registered.active.count


  end

    # Only allow a trusted parameter "white list" through.
    def placesavailable_params
      params.require(:placesavailable).permit(:institution_id, :schoolterm_id, :requested, :accredited, :authorized, :allowregistrations)
    end
end
