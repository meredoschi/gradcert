class AnnotationsController < ApplicationController
  before_action :set_annotation, only: [:show, :edit, :update, :destroy]

  before_action :set_registrations, only: [:new, :edit, :update]

	before_filter :authenticate_user! # By default... Devise

	load_and_authorize_resource  # CanCan(Can)

  # GET /annotations
  def index

	#	@annotations = Annotation.all

		@title=t('list')+' '+t('navbar.studentregistration').mb_chars.pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.studentregistration').mb_chars.pluralize.upcase
      @title+=' | '+tm('annotation').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.studentregistration').mb_chars.pluralize.upcase
        @title+=' | '+tm('annotation').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('annotation').pluralize.upcase

  		end

    end

    @all_annotations=Annotation.includes(registration: [student: :contact]).all

    @accessible_annotations=@all_annotations.accessible_by(current_ability)

    @all_registrations=Registration.includes(student: [contact: :personalinfo]).all

    @accessible_registrations=@all_registrations.accessible_by(current_ability)

  	@search = @accessible_annotations.ransack(params[:q])

  	@annotations=@search.result.ordered_by_contact_name.page(params[:page]).per(10)

#    @num_annotations=Annotation.accessible_by(current_ability).count

    @num_annotations=@accessible_annotations.count

		@ids_with_annotations=@accessible_registrations.ids_with_annotations

		@registrations_with_annotations=@accessible_annotations.where(id: @ids_with_annotations).ordered_by_contact_name # 1 or more events

    # Hotfix - bullet (eager loading for faster performance)
    @annotations_index_table=@annotations.includes(registration: [schoolyear: [program: :institution]]).includes(registration: [schoolyear: [program: :programname]])
    @annotations_index_table=@annotations_index_table.includes(:payroll)
  end

  # GET /annotations/1
  def show
  	@title=t('navbar.studentregistration').capitalize

#  	if !@annotation.name.nil?

#    	@title=@title+": "+@annotation.name

#     end

  	if is_admin_or_manager(current_user)

			@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+" | "+tm('annotation').capitalize+": "+@annotation.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar.studentregistration').mb_chars.upcase+' | '+t('annotation').capitalize

			else

				@title=tm('annotation').pluralize.upcase

				if !@annotation.name.nil?

					@title+=" : "+@annotation.name

				end

			end

		end

		@events=Event.for_registration_from_payroll(@annotation.registration,@annotation.payroll) #  1 or more generated this annotation

		@num_events=@events.accessible_by(current_ability).count

  end

  # GET /annotations/new
  def new
    @annotation = Annotation.new

  	#	@registrations=Registration.accessible_by(current_ability).current.ordered_by_contact_name

  #

    if is_admin_or_manager(current_user)

			@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+" | "+t('actions.new.f')+" "+tm('annotation')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+tm('annotation')

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+tm('annotation')

			end

		end

  end

  # GET /annotations/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('navbar.studentregistration')

    if is_admin_or_manager(current_user)

				@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+tm('annotation')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.studentregistration').mb_chars.pluralize.upcase+' | '+t('noun.edit')+' '+tm('annotation')

			else

 			  @title=t('noun.edit')+' '+tm('annotation').pluralize

			end

  	end

  end

  # POST /annotations
  def create
    @annotation = Annotation.new(annotation_params)

		record_zero_absences_when_manual

    if @annotation.save
      redirect_to @annotation, notice: tm('annotation').capitalize+' '+t('created.f')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /annotations/1
  def update

    if @annotation.update(annotation_params)
     # redirect_to @annotation, notice: 'Annotation was successfully updated.'
       redirect_to @annotation, notice: tm('annotation').capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /annotations/1
  def destroy
    @annotation.destroy
    redirect_to annotations_url, notice: tm('annotation').capitalize+' '+t('deleted.f')+' '+t('succesfully')

  end

  private

		# If it is a manual (i.e. exceptional case) annotation, absences would otherwise be null.

    def record_zero_absences_when_manual

			if @annotation.absences.nil?

				@annotation.absences=0

			end

		end

    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @annotation = Annotation.find(params[:id])
    end

    def set_registrations
      # Implemented for the new registration season 2017
      latest_payroll_start_date=Payroll.accessible_by(current_ability).actual.latest.first.start

      @registrations=Registration.accessible_by(current_ability).contextual_on(latest_payroll_start_date).current.ordered_by_contact_name

    end

    # Only allow a trusted parameter "white list" through.
    def annotation_params
      params.require(:annotation).permit(:registration_id, :payroll_id, :absences, :discount, :skip, :comment, :supplement, :confirmed, :automatic)
    end
end
