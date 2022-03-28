class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :edit, :update, :destroy, :calculate, :report, :clear, :absences]

#  before_action :set_report_variables, only: [:report, :show]

	before_action :authenticate_user! # By default... Devise

  before_action :check_for_annotations, only: [:destroy]

  before_action :check_if_done, only: [:destroy]

#	load_and_authorize_resource  # CanCan(Can)

# http://stackoverflow.com/questions/11117226/custom-actions-in-cancan
	load_and_authorize_resource :except => [:annotationsreport, :annotate, :deannotate, :multiple, :absences]

  # GET /payrolls
  def index

#     @payrolls = Payroll.ordered_by_reference_month # i.e. Month worked

#    @payrolls = Payroll.ordered_by_monthworked_paymentdate_special_createdat_desc

		@title=t('list')+' '+t('activerecord.models.payroll').pluralize

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase
      @title+=' | '+t('activerecord.models.payroll').capitalize.pluralize

    else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase
        @title+=' | '+t('activerecord.models.payroll').capitalize.pluralize

  		else

  			@title=t('my.mp').upcase+' '+tm('payroll').pluralize.upcase

  		end

    end


#  	@search = Payroll.ordered_by_reference_month.accessible_by(current_ability).ransack(params[:q])
    if is_admin_or_manager(current_user)

      @all_payrolls=Payroll.includes(:taxation).all

    else

      @all_payrolls=Payroll.all

    end
#    @all_payrolls=Payroll.all

    @payrolls_accessible=@all_payrolls.accessible_by(current_ability)
  	@search = @payrolls_accessible.ordered_by_most_recent.ransack(params[:q])

  	@payrolls=@search.result.page(params[:page]).per(10)
		@numpayrolls=@payrolls_accessible.count


  end

  # GET /payrolls/1/report

  def report

    redirect_to controller: 'annotationreports', action: 'show', payroll_id: @payroll.id

  end

  # GET /payrolls/1/clear

	# Clear all annotations for payroll
  def clear

  #    if @payroll.regular?

          clear_payroll.delay
 			redirect_to action: :report

  #    end

	end

	# Completion day in numeric format.  Number of days since application's "epoch"
	def finishday

	 	return (finish-Settings.dayone).to_i

	end

  # GET /payrolls/1/calculate
  def calculate

    if @payroll.annotated?

      clear_payroll.delay

    end

#		if @payroll.regular?

	    calculate_regular_payroll.delay # use delayed job to process it on the background

	#	else

		#	calculate_special_payroll

	#	end

    redirect_to action: :report # show annotations report upon completion

  end

  # GET /payrolls/1/absences
  def absences

    redirect_to controller: 'absentreports', action: 'show', payroll_id: @payroll.id

  end

  # GET /payrolls/1
  def show

  	@title=t('activerecord.models.payroll').capitalize

#  	if !@payroll.name.nil?

#    	@title=@title+": "+@payroll.name

#     end

#    get_payroll_annotations

    set_report_variables

  	if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('activerecord.models.payroll').capitalize+": "+@payroll.name

    else

 	 		if is_local_admin(current_user)

				@title=t('navbar.financial').to_s.upcase+' | '+t('activerecord.models.payroll').capitalize

			else

				@title=tm('payroll').pluralize.upcase

				if !@payroll.name.nil?

					@title+=" : "+@payroll.name

				end

			end

		end

  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new

    if is_admin_or_manager(current_user)

			@title=t('navbar.financial').upcase+" | "+t('actions.new.f')+" "+t('activerecord.models.payroll')

		else

			if is_local_admin(current_user)

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.payroll')

			else

		    @title=current_user.institution.name+": "+t('actions.new.f')+" "+t('activerecord.models.payroll')

			end

		end

  end

  # GET /payrolls/1/edit
  def edit

#     @title=t('noun.edit')+" "+t('activerecord.models.payroll')

    if is_admin_or_manager(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.payroll')

    	else

			if is_local_admin(current_user)

				@title=t('navbar.financial').upcase+' | '+t('noun.edit')+' '+t('activerecord.models.payroll')

			else

 			  @title=t('noun.edit')+' '+tm('payroll').pluralize

			end

  	end

  end

  # POST /payrolls
  def create
    @payroll = Payroll.new(payroll_params)


		set_sector
    set_number_of_days

    if @payroll.save
      redirect_to @payroll, notice: t('activerecord.models.payroll').capitalize+' '+t('created.f')+' '+t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /payrolls/1
  def update

		set_sector
		set_number_of_days

    if @payroll.update(payroll_params)
     # redirect_to @payroll, notice: 'Payroll was successfully updated.'
       redirect_to @payroll, notice: t('activerecord.models.payroll').capitalize+' '+t('updated.f')+' '+t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /payrolls/1
  def destroy
    @payroll.destroy
    redirect_to payrolls_url, notice: t('activerecord.models.payroll').capitalize+' '+t('deleted.f')+' '+t('succesfully')

  end

  private

  def set_report_variables

    @all_annotations=Annotation.includes(registration: [student: [contact: {user: :institution}]])
    @all_events=Event.includes(:leavetype).includes(:registration) # used in report_annotations view (bullet)
    @all_institutions=Institution.all
    @all_registrations=Registration.all
    @scholarship_for_payroll=Scholarship.in_effect_for(@payroll)

    @payroll_annotations=@all_annotations.for_payroll(@payroll)

    if !is_admin_or_manager(current_user)

      @payroll_annotations=@payroll_annotations.for_institution(current_user.institution)

    end

    @num_payroll_annotations=@payroll_annotations.count

  end

  def set_calculation_variables

    @all_annotations=Annotation.all
    #@all_brackets=Bracket.all
    @all_events=Event.all
#    @all_feedbacks=Feedback.all
    @all_registrations=Registration.all
  #  @all_schoolarships=Scholarship.all
#    @all_schoolterms=Schoolterm.all

  end



 # http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records
  def check_for_annotations

    if @payroll.annotated?
      flash[:warning] = "Não é possível remover uma folha com anotações."
#       render :action => :show

    end

  end

   # http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records
    def check_if_done

      if @payroll.done?
        flash[:warning] = "Não é possível remover uma folha já concluída."

      end

    end


  # Payroll variable already set previously
  def clear_payroll

  	@payroll_annotations=Annotation.automatic.for_payroll(@payroll)

  	@payroll_annotations.delete_all

  	@residual_events=Event.for_payroll(@payroll).residual

  	@residual_events.delete_all

    # -------------------------------------
    @payroll.update(annotated: false)
    # -------------------------------------

  end

  # Calculates regular payroll
  def calculate_regular_payroll

# 		@registrations=Registration.all

    set_calculation_variables

#    @registrations=Registration.contextual_on(@payroll.start) # Works for March as well (references february)

    @registrations=@all_registrations.contextual_on(@payroll.start) # Works for March as well (references february)

   	@payroll_interval=(@payroll.daystarted..@payroll.dayfinished)

    @cancelled_registrations=@registrations.cancelled_during_payroll(@payroll)

    @cancelled_registrations.each do |registration|

      accreditation=registration.accreditation

      if accreditation.confirmed?

        confirmation_status=true

      else

        confirmation_status=false

      end

      # Insufficient number of days worked in order to generate the first payment
      if registration.early_cancellation?

    #    if Annotation.exists_for_registration_on_payroll?(registration,@payroll)
        if @all_annotations.exists_for_registration_on_payroll?(registration,@payroll)

          annotation=registration.annotation.first # It is assumed there is only one.

          days_worked=registration.num_days_worked_before_cancelling

          txt=I18n.t('early_cancellation').capitalize+' '
          txt+=I18n.l(registration.accreditation.revocation, format: :compact)+' '
          txt+=I18n.t('nothing_due').downcase


          annotation.update(comment: txt, skip: true)

        else

#    	    annotation=Annotation.create! registration_id: registration.id, skip:true, payroll_id: @payroll.id, comment: I18n.t('early_cancellation').capitalize+': '+I18n.l(registration.accreditation.revocation), supplement_cents: 0, discount_cents: 0, confirmed: confirmation_status

          annotation=@all_annotations.create! registration_id: registration.id, skip:true, payroll_id: @payroll.id, comment: I18n.t('early_cancellation').capitalize+': '+I18n.l(registration.accreditation.revocation), supplement_cents: 0, discount_cents: 0, confirmed: confirmation_status

       end

	    else

#	       event=Event.create! registration_id: registration.id, residual: true, start: registration.accreditation.revocation, daystarted: (registration.accreditation.revocation-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: confirmation_status

         event=@all_events.create! registration_id: registration.id, residual: true, start: registration.accreditation.revocation, daystarted: (registration.accreditation.revocation-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: confirmation_status

			end

		end


	  @suspended_registrations=@registrations.suspended_during_payroll(@payroll)

    @suspended_registrations.each do |suspended_registration, k|

#     	event=Event.create! registration_id: suspended_registration.id, residual: true, start: suspended_registration.accreditation.suspension, daystarted: (suspended_registration.accreditation.suspension-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true
#    	event=Event.create! registration_id: suspended_registration.id, residual: true, start: suspended_registration.accreditation.suspension, daystarted: (suspended_registration.accreditation.suspension-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: true
      event=@all_events.create! registration_id: suspended_registration.id, residual: true, start: suspended_registration.accreditation.suspension, daystarted: (suspended_registration.accreditation.suspension-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: true

    end

	  # -----------------------------------------------------------------------------------------------

    @late_registrations=@registrations.late_during_payroll(@payroll)

    @late_registrations.each do |registration, k|

    	# monthwork = reference month = 1st day of the month
			first_of_month=@payroll.monthworked.beginning_of_month
			eve_of_registration=registration.accreditation.start-1

#			event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_registration, dayfinished: to_numeric_date(eve_of_registration), absence:true
#			event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_registration, dayfinished: to_numeric_date(eve_of_registration), absence:true, confirmed: true

      event=@all_events.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_registration, dayfinished: to_numeric_date(eve_of_registration), absence:true, confirmed: true

	  end

	  @renewed_registrations=@registrations.renewed_during_payroll(@payroll)

    @renewed_registrations.each do |registration, k|

	    @renewal_date=registration.accreditation.renewal

			first_of_month=@payroll.monthworked.beginning_of_month
			eve_of_renewal=registration.accreditation.start-1

			if first_of_month?(@renewal_date)

				@remark=I18n.t('activerecord.registration.accreditation.renewal')+' '+I18n.l(@renewal_date , :format => :dmy)

#       Confirmed attribute on annotations deprecated, placed on events
#				annotation=Annotation.create! registration_id: registration.id, skip:false, payroll_id: @payroll.id, absences: 0, confirmed: true, supplement_cents: 0, discount_cents: 0, comment: @remark

#				annotation=Annotation.create! registration_id: registration.id, skip:false, payroll_id: @payroll.id, absences: 0, supplement_cents: 0, discount_cents: 0, comment: @remark
        annotation=@all_annotations.create! registration_id: registration.id, skip:false, payroll_id: @payroll.id, absences: 0, supplement_cents: 0, discount_cents: 0, comment: @remark

			# Create event normally
			else

# 				event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_renewal, dayfinished: to_numeric_date(eve_of_renewal), absence:true

#       Added confirmed attribute for events

#				event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_renewal, dayfinished: to_numeric_date(eve_of_renewal), absence:true, confirmed: true
        event=@all_events.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_renewal, dayfinished: to_numeric_date(eve_of_renewal), absence:true, confirmed: true

			end

	  end

#     payroll_events=Event.for_payroll(@payroll)

#    payroll_events=Event.confirmed.for_payroll(@payroll) # Added filter for confirmed events only

#    payroll_events=Event.confirmed.for_payroll(@payroll).contextual_on(@payroll.monthworked) # Added context

    payroll_events=@all_events.confirmed.for_payroll(@payroll).contextual_on(@payroll.monthworked) # Added context

#		registration_ids_with_events=Event.registration_ids_for_payroll(@payroll)

    registration_ids_with_events=@all_events.registration_ids_for_payroll(@payroll)

    registration_ids_with_events.each_with_index do |r_id, i|

#			r=Registration.find(r_id)

      r=@all_registrations.find(r_id)

				registration_events=payroll_events.for_registration(r)

			  student_unpaid_absences=0
			  total_num_days=0

	  		registration_events.each_with_index do |e, j|

					num_days=Logic::intersection_size(e.interval,@payroll_interval)

          student_unpaid_absences+=calculate_absence_penalty(e, num_days)

          total_num_days+=num_days

				end

		#		if Annotation.exists_for_registration_on_payroll?(r,@payroll)

        if @all_annotations.exists_for_registration_on_payroll?(r,@payroll)

#    	   annotation=Annotation.for_registration_on_payroll(r,@payroll).first

          annotation=@all_annotations.for_registration_on_payroll(r,@payroll).first

#     	   Annotation.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, automatic: false)
#      	   Annotation.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, automatic: false)

#           @all_annotations.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, automatic: false)
           @all_annotations.update(annotation.id, payroll_id: @payroll.id, absences: student_unpaid_absences, automatic: false)


 				else

#     	   annotation=Annotation.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, supplement_cents: 0, discount_cents: 0

# 	    	   annotation=Annotation.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, supplement_cents: 0, discount_cents: 0

#           annotation=@all_annotations.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, supplement_cents: 0, discount_cents: 0

           annotation=@all_annotations.create! registration_id: r.id, automatic:true, payroll_id: @payroll.id, absences: student_unpaid_absences, supplement_cents: 0, discount_cents: 0

 				end

 				if totally_absent?(@payroll_interval.size, student_unpaid_absences)

					annotation.update(skip: true)

				end

  	end

      # -------------------------------------
      @payroll.update(annotated: true)
      # -------------------------------------

  end

  # Calculates special payroll
  def calculate_special_payroll


		feedback_reg_ids=Feedback.for_payroll(@payroll).pluck(:registration_id) # Get registration ids from feedbacks

		@registrations=Registration.where(id: feedback_reg_ids)

		dstart=(@payroll.monthworked.beginning_of_month-Settings.dayone).to_i
		dfinish=(@payroll.monthworked.end_of_month-Settings.dayone).to_i

   	@payroll_interval=(dstart..dfinish) #

		# Get events, based on reference month rather than payroll_id

    payroll_events=Event.on_month(@payroll.monthworked).contextual_on(@payroll.monthworked) # Added context

		registration_ids_with_events=payroll_events.where(registration_id: @registrations)

    registration_ids_with_events.each_with_index do |r_id, i|

			r=Registration.find(r_id)

				registration_events=payroll_events.for_registration(r)

			  student_unpaid_absences=0
			  total_num_days=0

	  		registration_events.each_with_index do |e, j|

					num_days=Logic::intersection_size(e.interval,@payroll_interval)
					student_unpaid_absences+=calculate_absence_penalty(e, num_days)
					total_num_days+=num_days

				end

				if Annotation.exists_for_registration_on_payroll?(r,@payroll)

    	   annotation=Annotation.for_registration_on_payroll(r,@payroll).first

    	   Annotation.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, automatic: false)

 				else

    	   annotation=Annotation.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, supplement_cents: 0, discount_cents: 0

 				end

 				if totally_absent?(@payroll_interval.size, student_unpaid_absences)

					annotation.update(skip: true)

				end

  	end

      # -------------------------------------
      @payroll.update(annotated: true)
      # -------------------------------------



  end

	def annotate_events



	end

		# Set days since application's Epoch

	# According to the Event Type.

		# For the entire payroll cycle (e.g. month)

		def totally_absent?(days_in_payroll_cycle, num_days_absent)

			return num_days_absent>=days_in_payroll_cycle # defensive programming, could have been equal.

		end

		def calculate_absence_penalty(event, absences)

			if event.paid_leave?

				return 0

			else

		  	return absences

			end

		end

  def calculate_absence_penalty_to_fix(event, absences)

    @offset=0

  if event.limited_leave?

    if absences>=event.leavetype.dayswithpaylimit

      if (event.finish.beginning_of_month-event.start.beginning_of_month > 0)

        @offset=(event.start.beginning_of_month.next_month-event.start).to_i # i.e. deducted days already "enjoyed" on the previous month

      end

      return (absences-@offset)-(event.leavetype.dayswithpaylimit-@offset)

      else

        return 0

      end

  else

    if event.paid_leave?

      return 0

    else

      return absences

    end

  end

end

		# Applies to managers only
    def set_sector

			if is_pap_manager(current_user)

				@payroll.pap=true

			end

			if is_medres_manager(current_user)

				@payroll.medres=true

			end

    end

    def set_number_of_days

			@payroll.daystarted=@payroll.startday
			@payroll.dayfinished=@payroll.finishday

		end

    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payroll_params
      params.require(:payroll).permit(:paymentdate, :done, :pap, :medres, :amount, :annotated, :comment, :taxation_id, :special, :scholarship_id, :monthworked, :daystarted, :dayfinished, :dataentrystart, :dataentryfinish)
    end
end
