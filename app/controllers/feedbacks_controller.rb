class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

	before_action :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /feedbacks
  def index
    @title=t('list')+' '+t('activerecord.models.feedback').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase
      @title+=' | '+t('activerecord.models.feedback').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase
        @title+=' | '+t('activerecord.models.feedback').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('feedback').pluralize.upcase

  		end

    end


#  	@search = Feedback.accessible_by(current_ability).ransack(params[:q])

    @feedbacks_eager_loaded=Feedback.includes(registration: [student: :contact]).includes(registration: [schoolyear: {program: :programname}]).includes(registration: {schoolyear: [program: :schoolterm]}).includes(:bankpayment)

    @feedbacks_accessible=@feedbacks_eager_loaded.accessible_by(current_ability).ordered_by_contact_name

    @search = @feedbacks_accessible.ransack(params[:q])

  	@feedbacks=@search.result.page(params[:page]).per(10)

  	@numfeedbacks=@feedbacks_accessible.count

  end

  # GET /feedbacks/1
  def show

  	@title=t('activerecord.models.feedback').capitalize

#  	if !@feedback.name.nil?

#    	@title=@title+": "+@feedback.name

#     end

  	if is_admin_or_manager(current_user)

			if @feedback.regular_bankpayment?

				@title=t('navbar.financial').upcase+" | "+t('activerecord.models.feedback').capitalize+": "+@feedback.name

			else

				@title=t('navbar.financial').upcase+" | "+t('supplemental_remittance').capitalize+": "+@feedback.registration.name

			end


    else

 	 		if is_local_admin(current_user)

				@title=t('navbar_menu_name').mb_chars.upcase+' | '+t('activerecord.models.feedback').capitalize

			else

				@title=tm('feedback').pluralize.upcase

				if !@feedback.name.nil?

					@title+=" : "+@feedback.name

				end

			end

		end

  end

  # GET /feedbacks/new
  def new

    @feedback = Feedback.new

    set_registrations

    if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('actions.new.m')+" "+t('activerecord.models.feedback')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.feedback')

			else

		    @title=current_user.institution.name+": "+t('actions.new.m')+" "+t('activerecord.models.feedback')

			end

		end

  end

  # GET /feedbacks/1/edit
  def edit

    set_registrations

#     @title=t('noun.edit')+" "+t('activerecord.models.feedback')

    if is_admin_or_manager(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.feedback')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.feedback')

			else

 			  @title=t('noun.edit')+' '+tm('feedback').pluralize

			end

  	end


  end

  # POST /feedbacks
  def create

    @statements=Statement.all

    @feedback = Feedback.new(feedback_params)

    if @feedback.save


			statement=@statements.for_registration(@feedback.registration).first

      if statement
	       @statements.destroy(statement.id)
      end

      redirect_to @feedback, notice: t('activerecord.models.feedback').capitalize+' '+t('created.m')+' '+t('succesfully')

    else
      render :new
    end
  end

  # PATCH/PUT /feedbacks/1
  def update
    if @feedback.update(feedback_params)
     # redirect_to @feedback, notice: 'Feedback was successfully updated.'
       redirect_to @feedback, notice: t('activerecord.models.feedback').capitalize+' '+t('updated.m')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /feedbacks/1
  def destroy
    @feedback.destroy
    redirect_to feedbacks_url, notice: t('activerecord.models.feedback').capitalize+' '+t('deleted.m')+' '+t('succesfully')

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def set_registrations

    #  dt=Payroll.latest.first.monthworked-2.months # Allow for up to two months in the past

      dt=Date.today-(Settings.feedback.registrations_contextual_from.number_days_ago).days

      @registrations=Registration.includes(student: [contact: :personalinfo]).includes(schoolyear: :program).ordered_by_contact_name # eager loaded , bullet

#      @registrations_contextual_today=@registrations.contextual_today

#      @ids_contextual_today=@registrations_contextual_today.pluck(:id)

#      @registrations_contextual_previously=@registrations.contextual_on(dt)

#      @ids_contextual_previously=@registrations_contextual_previously.pluck(:id)

#      @ids_contextual_today_or_in_the_recent_past=@ids_contextual_previously+@ids_contextual_today

#      @contextual_registrations=@registrations_contextual_today

#      @contextual_registrations=@registrations.where(id: @ids_contextual_today_or_in_the_recent_past)

      @contextual_registrations=@registrations.contextual_from(dt).ordered_by_contact_name

#      @contextual_registrations=Registration.includes(student: [contact: :personalinfo]).includes(schoolyear: :program).contextual_on(dt).ordered_by_contact_name # eager loaded , bullet
      @registrations_with_program_names_schoolterms=@contextual_registrations.includes(schoolyear: [program: :programname]).includes(schoolyear: [program: :schoolterm])
      @registrations_with_institutions=@contextual_registrations.includes(schoolyear: [program: :institution]) # Joined by program.  Important: it is assumed that contacts belong to the institutions.

    end
    # Only allow a trusted parameter "white list" through.
    def feedback_params
      params.require(:feedback).permit(:registration_id, :bankpayment_id, :processingdate, :approved, :processed, :comment)
    end
end
