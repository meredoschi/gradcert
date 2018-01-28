# Once payroll is closed (completed, not pending), bankpayment may be performed
class BankpaymentsController < ApplicationController
  #   before_action :set_bankpayment, only: [:show, :edit, :update, :destroy]

  before_action :set_bankpayment, only: %i[show edit update destroy statements]

  helper_method :gross_payment

  before_filter :authenticate_user! # By default... Devise

  load_and_authorize_resource # CanCan(Can)

  @seq = [1, 2, 3]

  # GET /bankpayments
  def index
    @title = index_action_title

    @search = Bankpayment.by_most_recent_payroll.accessible_by(current_ability).ransack(params[:q])
    @bankpayments = @search.result.page(params[:page]).per(10)
    @numbankpayments = Bankpayment.count

    @payrolls_with_bankpayment = Payroll.newest_first.with_bankpayment
  end

  # GET /bankpayments/1
  def producestatements
    redirect_to controller: 'producestatements', action: 'show', bankpayment_id: @bankpayment.id
  end

  # GET /bankpayments/1
  def reportwait
    flash[:notice] = 'Aguarde'

    redirect_to report_path
  end

  # GET /bankpayments/1
  def report
    flash[:notice] = 'Relatório gerado'

    @totalpayments = 0

    @title = t('navbar.financial').upcase + ' | ' + t('activerecord.models.bankpayment').capitalize + ' | ' + t('report')

    #     process_payroll(@bankpayment)
    calculate_payroll(@bankpayment)

    #     @actual_payroll_amount=compute_total_payments
  end

  # GET /bankpayments/1
  def show
    @title = t('navbar.financial').upcase
    @title += ' | ' + t('activerecord.models.bankpayment').capitalize

    @all_events = Event.all
    @vacations_on_this_payroll = @all_events.accessible_by(current_ability).for_payroll(@bankpayment.payroll).vacation

    calculate_payroll(@bankpayment)
    # 		@actual_payroll_amount=compute_total_payments
  end

  # GET /bankpayments/1
  def totalreport
    calculate_payroll(@bankpayment)
    @social_security_total_amount = 0

    @social_security_total_cents = 0

    @payroll = @bankpayment.payroll

    @payroll_annotations_not_skipped = Annotation.for_payroll(@payroll).not_skipped

    @num_days = @payroll.dayfinished - @payroll.daystarted + 1

    @absences = @payroll_annotations_not_skipped.sum(:absences)

    @supplements = Money.new(@payroll_annotations_not_skipped.sum(:supplement_cents))
    @discounts = Money.new(@payroll_annotations_not_skipped.sum(:discount_cents))

    @scholarship_amount = Scholarship.first.amount # Important to do: make this more generic! Implement: currently_active method

    @total_gross_amount = @scholarship_amount * @num_confirmed_for_payment

    # 	@scholarship_amount=1044.70

    #     @absences_total_amount=@scholarship_amount*@absences/30

    #     @absences_total_amount=@scholarship_amount*@absences/30

    @absences_total_amount = @scholarship_amount * @absences / @num_days

    @subtotal = @total_gross_amount + @supplements - @discounts - @absences_total_amount

    @social_security_rate = @payroll.taxation.socialsecurity.to_i / 100.0

    @social_security = @subtotal * @social_security_rate

    @net = @subtotal - @social_security

    @rounding = @net - @bankpayment.totalamount
    @absences_adjustment = @rounding / (1 - @social_security_rate)
    @annotated_registrations = Registration.annotations_for_payroll(@bankpayment.payroll)
    # @scholarship_amount=Scholarship.for_payroll(@bankpayment.payroll)

    @absences_final_amount = @absences_total_amount + @absences_adjustment

    @subtotal_recalc = @subtotal - @absences_adjustment

    @social_security_recalc = @subtotal_recalc * @social_security_rate

    @net_recalc = @subtotal_recalc - @social_security_recalc
  end

  # GET /bankpayments/new
  def new
    @bankpayment = Bankpayment.new

    #    @possible_payrolls = Payroll.incomplete

    @possible_payrolls = Payroll.without_bankpayment.ordered_by_most_recent

    @num_possible_payrolls = @possible_payrolls.count

    if is_admin_or_manager(current_user)

      @title = t('navbar.financial').upcase + ' | ' + t('actions.new.m') + ' ' + t('activerecord.models.bankpayment')

    else

      if is_local_admin(current_user)

        @title = current_user.institution.name + ': ' + t('actions.new.m') + ' ' + t('activerecord.models.bankpayment')

      else

        @title = current_user.institution.name + ': ' + t('actions.new.m') + ' ' + t('activerecord.models.bankpayment')

      end

    end
  end

  # GET /bankpayments/1/edit
  def edit
    #     @title=t('noun.edit')+" "+t('activerecord.models.bankpayment')

    if is_admin_or_manager(current_user)

      @title = t('navbar.financial').upcase + ' | ' + t('noun.edit') + ' ' + t('activerecord.models.bankpayment')

    else

      if is_local_admin(current_user)

        @title = t('navbar.financial').upcase + ' | ' + t('noun.edit') + ' ' + t('activerecord.models.bankpayment')

      else

        @title = t('noun.edit') + ' ' + tm('bankpayment').pluralize

      end

    end
  end

  # POST /bankpayments
  def create
    @bankpayment = Bankpayment.new(bankpayment_params)

    if @bankpayment.save
      redirect_to @bankpayment, notice: t('activerecord.models.bankpayment').capitalize + ' ' + t('created.m') + ' ' + t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /bankpayments/1
  def update
    # 		clear_statements

    if @bankpayment.update(bankpayment_params)
      # redirect_to @bankpayment, notice: 'Bankpayment was successfully updated.'
      redirect_to @bankpayment, notice: t('activerecord.models.bankpayment').capitalize + ' ' + t('updated.m') + ' ' + t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /bankpayments/1
  def destroy
    @bankpayment.destroy
    redirect_to bankpayments_url, notice: t('activerecord.models.bankpayment').capitalize + ' ' + t('deleted.m') + ' ' + t('succesfully')
  end

  private

  def index_action_title
    prefix = t('navbar.financial').upcase + ' | '
    i18n_bankpayments = t('activerecord.models.bankpayment').capitalize.pluralize

    title = if is_admin_or_manager(current_user) then prefix + i18n_bankpayments
            elsif is_local_admin(current_user) then prefix + i18n_bankpayments
            else prefix + i18n_bankpayments # Added for completeness
    end

    title
  end

  def gross_amount_with_adjustments(registration)
    gross_amount = gross_payment_due(registration)

    adjustments = calculate_adjustments(registration)

    gross_amount += adjustments # Discounts or Suplements

    gross_amount.cents
  end

  def clear_statements
    if @bankpayment.unprepared?

      @statements = Statement.for_bankpayment(@bankpayment)

      @num_statements = @statements.count

      @statements.delete_all if @num_statements > 0

    end
  end

  # http://stackoverflow.com/questions/5980971/in-rails-can-you-set-flasherror-when-calling-link-to

  # Flash message
  def wait_for_report
    flash[:notice] = params[:wait_notice]
    action = "#{params[:redirect_action]}_path"
    redirect_to action
  end

  def calculate_adjustments(registration)
    annotation = Annotation.for_registration_on_payroll(registration, @bankpayment.payroll).first

    #    annotation=Annotation.for_registration_on_payroll(registration,@actual_payroll).first (reworked?)

    impact = if annotation.present? && annotation.supplement.present? && annotation.discount.present?

               annotation.supplement - annotation.discount

             else

               0

             end

    impact
  end

  def calculate_absence_penalty(annotation, monthsize, payment)
    if !annotation.assiduous?

      ((payment / monthsize) * annotation.absences)

    else

      0

      end
  end

  def gross_payment_due(registration)
    # quickfix

    payment = set_payment_amount

    @payroll = @bankpayment.payroll

    monthsize = days_for_month(@payroll.monthworked)

    #			if	Annotation.exists_for_registration_on_payroll?(registration,@bankpayment.payroll)

    if	@all_annotations.exists_for_registration_on_payroll?(registration, @payroll)

      #			annotation=Annotation.for_registration_on_payroll(registration,@bankpayment.payroll).first

      annotation = @all_annotations.for_registration_on_payroll(registration, @payroll).first

      # Debug

      # byebug

      absence_penalty = calculate_absence_penalty(annotation, monthsize, payment)

      payment -= absence_penalty

      payment = 0 if annotation.skip?

    end

    payment
  end

  def compute_total_payments
    totalpayments = 0

    @confirmedregistrations.each_with_index do |registration, _n|
      gross_amount = gross_payment_due(registration)

      social_security_fee = Taxes.social_security(@bankpayment, gross_amount)

      income_tax_due = Taxes.personal_income(@brackets, gross_amount, social_security_fee) # social security paid counts as a deduction

      net_payment = (gross_amount - social_security_fee - income_tax_due).to_i

      totalpayments += net_payment
    end

    totalpayments
  end

  def calculate_payroll(bankpayment)
    set_calculation_variables

    @p = bankpayment.payroll

    #    @registrations_in_context=Registration.contextual_on(@p.monthworked) # new for 2017

    @registrations_in_context = @all_registrations.contextual_on(@p.monthworked) # new for 2017

    # New for 2017
    #    @p_schoolterm=Schoolterm.for_payroll(@p)

    @p_schoolterm = @all_schoolterms.for_payroll(@p)

    if bankpayment.resend?

      #			@registration_ids_with_feedback=Feedback.pending.registration_ids_for_bankpayment(bankpayment)
      # Hotfix
      @registration_ids_with_feedback = @all_feedbacks.registration_ids_for_bankpayment(bankpayment)

      @registrations = @registrations_in_context.accessible_by(current_ability).where(id: @registration_ids_with_feedback)

      #      @p=Payroll.where(monthworked: @bankpayment.payroll.monthworked).regular.first

      @num_returned_payments = @registrations.count

    else

      @registrations = @registrations_in_context.accessible_by(current_ability)

    end

    #    @p_annotations=Annotation.accessible_by(current_ability).for_payroll(@p).ordered_by_contact_name

    @p_annotations = @all_annotations.accessible_by(current_ability).for_payroll(@p).ordered_by_contact_name

    @normal = @registrations.regular_for_payroll(@p)
    @cancelled = @registrations.cancelled_on_this_payroll(@p)
    @suspended = @registrations.suspended_on_this_payroll(@p)
    @renewed = @registrations.renewed_on_this_payroll(@p)

    @possible_ids = @normal

    @possible = @registrations.where(id: @possible_ids)

    @num_normal = @normal.count
    @num_cancelled = @cancelled.count
    @num_suspended = @suspended.count
    @num_renewed = @renewed.count

    @num_possible = @possible.count

    @num_payroll_annotations = @p_annotations.count

    @adjustments = @p_annotations.adjustment

    @num_adjustments = @adjustments.count

    @skip_payment = @registrations.skipped_students_for_payroll(@p)

    @skip_payment_ids = @skip_payment.pluck(:id)

    @num_skip_payment = @skip_payment.count

    @regular_annotations = @p_annotations.regular

    @num_regular_annotations = @regular_annotations.count

    @present_annotations = @regular_annotations.automatic.frequent # Filter manual annotations

    @num_present_annotations = @present_annotations.count

    @absent_annotations = @regular_annotations.absent

    @num_absent_annotations = @absent_annotations.count

    @num_regular_annotations = @regular_annotations.count

    @confirmedregistrations = @possible.where.not(id: @skip_payment_ids)

    @num_confirmed_for_payment = @confirmedregistrations.count

    #    @brackets=Bracket.for_taxation(bankpayment.payroll.taxation)

    @brackets = @all_brackets.for_taxation(bankpayment.payroll.taxation)

    @regular_payment = set_payment_amount # Regular payment amount for the payroll (i.e. for most people)
  end

  def social_security_tax(payment)
    taxation = @bankpayment.payroll.taxation

    taxes = payment * taxation.socialsecurity

    taxes /= 100.to_i

    taxes
  end

  def set_payment_amount
    # if @bankpayment.payroll.special?

    # 		 payment=@bankpayment.payroll.amount

    # 	else

    payment = Scholarship.for_payroll(@bankpayment.payroll).first.amount

    #  	end

    payment
  end

  def gross_payment(registration)
    payment = @regular_payment

    annotation = Annotation.for_registration_on_payroll(registration, @bankpayment.payroll).first

    days_in_month = days_for_month(@bankpayment.payroll.monthworked)

    if annotation.present?

      if annotation.absences.present? && annotation.absences > 0

        absence_penalty = ((payment / days_in_month) * annotation.absences)

        payment -= absence_penalty

      end

      payment -= annotation.discount if annotation.discount.present? # defensive programming - check for nil

      payment += annotation.supplement if annotation.supplement.present?

    end

    payment
  end

  def set_bankpayment
    @bankpayment = Bankpayment.find(params[:id])
  end

  def set_calculation_variables
    @all_annotations = Annotation.all
    @all_brackets = Bracket.all
    @all_feedbacks = Feedback.all
    @all_registrations = Registration.all
    @all_schoolarships = Scholarship.all
    @all_schoolterms = Schoolterm.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_bankpayment
    @bankpayment = Bankpayment.find(params[:id])
  end

  # f=filename - used for debugging
  def ruler(f)
    f.puts('         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4')
    f.puts('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890')
  end

  # Only allow a trusted parameter "white list" through.
  def bankpayment_params
    params.require(:bankpayment).permit(:payroll_id, :comment, :sequential, :prepared, :totalamount, :done, :resend)
  end
end
