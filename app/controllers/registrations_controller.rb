# Handles logic associated with registrations
class RegistrationsController < ApplicationController
  before_action :set_registration, only: %i[show edit update destroy report declaration registrations_report export]

  before_filter :authenticate_user! # By default... Devise

  load_and_authorize_resource # CanCan(Can)

  #   before_action :set_schoolterm, only: [:create]
  # Deprecated

  # GET /registrations
  def index
    @registrations = Registration.ordered_by_name_and_institution

    @all_registrations = @registrations.includes(student: :contact).includes(:annotation).includes(:accreditation).includes(schoolyear: [program: :schoolterm]).includes(schoolyear: [program: :programname]).includes(schoolyear: [program: :institution])

    @registrations_for_current_ability = @all_registrations.accessible_by(current_ability)

    # http://stackoverflow.com/questions/27890997/ransack-return-records-with-boolean-attribute-both-true-and-false-with-checkbox

    if params[:q]
      @params = params[:q]
      # confirmation search
      @params.delete(:accreditation_confirmed_true) if @params[:accreditation_confirmed_true] = '0'
    # status search
    else
      @params = []
    end

    @search = @registrations_for_current_ability.ransack(params[:q])

    @registrations_without_pagination = @search.result

    @registrations = @registrations_without_pagination.page(params[:page]).per(10)

    @numregistrations = @registrations_for_current_ability.count

    @all_institutions = Institution.accessible_by(current_ability)

    @title = t('list') + ' ' + t('activerecord.models.registration').pluralize

    # Special registration kinds

    @makeup_registrations = @registrations_for_current_ability.makeup
    @repeat_registrations = @registrations_for_current_ability.repeat

    @num_makeup_registrations = @makeup_registrations.count
    @num_repeat_registrations = @repeat_registrations.count

    @num_special_registrations = @num_makeup_registrations + @num_repeat_registrations

    if is_admin_or_manager(current_user)

      @title = t('navbar.studentregistration').mb_chars.pluralize.upcase
      @title += ' | ' + t('activerecord.models.registration').capitalize.pluralize

    else

      if is_local_admin(current_user)

        @title = t('navbar.studentregistration').mb_chars.pluralize.upcase
        @title += ' | ' + t('activerecord.models.registration').capitalize.pluralize

      else

        @title = t('my.mp').upcase + ' ' + tm('registration').pluralize.upcase

      end

    end

    @filtered_registrations = @registrations_without_pagination

    #    @id_debug=[1,2,3,4,5,6,7]

    #    @id_debug=Registration.limit(500).pluck(:id) # Alias

    respond_to do |format|
      format.html
      format.csv { send_data @filtered_registrations.to_csv }
    end
  end

  # GET /registrations/1
  def show
    @title = t('activerecord.models.registration').capitalize

    @events = Event.all

    if @registration.annotated?

      @annotations = @registration.annotations.ordered_by_most_recent_payroll

      # Includes late registrations and cancellation residuals

      @accounting_absences_total = @annotations.pluck(:absences).compact.sum

      # Quickfix - December 2017 - Marcelo
      # Added .compact to filter nil absence values
      
      # https://stackoverflow.com/questions/15276853/treating-nil-as-zero-in-sum-function
      # rake debug_dec_17:early_cancellation_annotations

      # Equivalent to
      # @absences_total=Event.for_registration(@registration).absences_total

      #       @actual_absence_events=Event.with_actual_absences_for(@registration)

      @actual_absence_events = @events.with_actual_absences_for(@registration)

      @actual_absences_total = @actual_absence_events.absences_total

    end

    # Defensive programming
    if @registration.vacationed?

      @vacations = @events.vacations_for_registration(@registration)

      @num_vacations = @vacations.count

#      @total_days_vacationed = @events.enjoyed_vacation_days_for_registration(@registration)
#      Hotfix, method name changed!
      @total_days_vacationed = @events.days_vacationed(@registration)

    end

    #  	if !@registration.student_name.nil?

    #    	@title=@title+": "+@registration.student_name

    #     end

    if is_admin_or_manager(current_user)

      @title = t('navbar.studentregistration').mb_chars.pluralize.upcase + ' | ' + t('activerecord.models.registration').capitalize + ': ' + @registration.student_name

    else

      if is_local_admin(current_user)

        @title = t('navbar.studentregistration').mb_chars.upcase + ' | ' + t('activerecord.models.registration').capitalize

      else

        @title = tm('registration').pluralize.upcase

        unless @registration.student_name.nil?

          @title += ' : ' + @registration.student_name

        end

      end

    end

    if @registration.special? # from model

      @previous_registration_id = @registration.registrationkind.previousregistrationid

      @previous_registration = Registration.where(id: @previous_registration_id).first

    end

    check_log
  end

  # GET /registrations/new
  def new
    @registration = Registration.new

    @students = Student.accessible_by(current_ability)

    if is_admin_or_manager(current_user)

      @title = t('navbar.studentregistration').mb_chars.pluralize.upcase + ' | ' + t('perform').capitalize + ' ' + t('a.f') + ' ' + t('new.f') + ' ' + tm('registration')

    else

      if is_local_admin(current_user)

        @title = current_user.institution.name + ': ' + t('actions.new.m') + ' ' + t('activerecord.models.registration')

      else

        @title = current_user.institution.name + ': ' + t('actions.new.m') + ' ' + t('activerecord.models.registration')

      end

    end

    #  @registration.build_accreditation
    #        @registration.build_accreditation(registration_id: @registration.id, original: true, start: '2017-3-1')
    @registration.build_accreditation(registration_id: @registration.id, original: true)

    #  Added for 2017
    @registration.build_completion(registration_id: @registration.id, inprogress: true, pass: false, failure: false, mustmakeup: false, dnf: false)
    @registration.build_registrationkind(registration_id: @registration.id, regular: true, makeup: false, repeat: false)
    # set_registration_date

    @students_yet_to_be_registered = Student.accessible_by(current_ability).not_registered

    if !@students_yet_to_be_registered.nil?

      @num_students_yet_to_be_registered = @students_yet_to_be_registered.count

    else

      @num_students_yet_to_be_registered = 1

    end

    @schoolyears = Schoolyear.full.accessible_by(current_ability).ordered_by_programname_and_year

    @num_schoolyears = @schoolyears.count

    #     if is_local_admin(current_user)

    #      @current_enrollment=@all_registrations.from_institution(current_user).on_schoolterm(Schoolterm.latest).count

    #    end
  end

  # GET /registrations/1/edit
  def edit
    #     @title=t('noun.edit')+" "+t('activerecord.models.registration')

    if is_admin_or_manager(current_user)

      @title = t('navbar.studentregistration').mb_chars.pluralize.upcase + ' | ' + t('noun.edit') + ' ' + t('student_situation')

    else

      if is_local_admin(current_user)

        @title = t('navbar.studentregistration').mb_chars.pluralize.upcase + ' | ' + t('noun.edit') + ' ' + t('student_situation')

      else

        @title = t('noun.edit') + ' ' + tm('registration').pluralize

      end

      @available_students = Student.accessible_by(current_ability).not_barred.not_registered

      @num_available_students = @available_students.count

    end

    # See: registrations_helper.rb
    @all_registrations = Registration.all

    set_current_schoolyears

    @registration_term = Schoolterm.latest

    #    @remaining_vacancies=remaining_vacancies_on_schoolyear(@registration_term)
  end

  # POST /registrations
  def create
    @registration = Registration.new(registration_params)

    set_sector

    set_confirmation_status_for_creation

    @available_students = Student.accessible_by(current_ability).not_barred.not_registered

    @num_available_students = @available_students.count

    if @registration.save
      redirect_to @registration, notice: t('activerecord.models.registration').capitalize + ' ' + t('created.f') + ' ' + t('succesfully')
    else
      render :new
    end
  end

  # PATCH/PUT /registrations/1
  def update
    set_sector

    set_confirmation_status_for_update

    set_current_schoolyears
    if @registration.update(registration_params)
      # redirect_to @registration, notice: 'Registration was successfully updated.'
      redirect_to @registration, notice: t('activerecord.models.registration').capitalize + ' ' + t('updated.f') + ' ' + t('succesfully')
    else
      render :edit
    end
  end

  # DELETE /registrations/1
  def destroy
    @registration.destroy
    redirect_to registrations_url, notice: t('activerecord.models.registration').capitalize + ' ' + t('deleted.f') + ' ' + t('succesfully')
  end

  #  ---- Custom actions ----

  # Export results to a report on PDF
  def export
    @title = t('registrations_report.screen_title')

    @filtered_registration_ids = params[:filtered_registration_ids].split('/')

    #    redirect_to controller: 'reports', action: 'show', filtered_registration_ids: @filtered_registration_ids

    #    redirect_to controller: 'reports', action: 'show', filtered_registration_ids: [1,2,3,4]

    redirect_to controller: 'reports', action: 'displayregistrations', filtered_registration_ids: Registration.all.pluck(:id)
  end

  def self.csv
    @num_filtered_registrations = @filtered_registrations.count

    @fname = I18n.t('registrations_report.filename_prefix') + '_' + Pretty.right_now + '.csv'

    # 		<%= registration.tin %> <%= registration.id.to_s %> <%= registration.student.previouscode %>

    sep = ';' # separator

    File.open(@fname, 'w+') do |f|
      f.print 'N' + sep
      f.print ta('contact.name').capitalize + sep
      f.print ta('webinfo.email').capitalize + sep
      f.print ta('schoolyears.programyear').capitalize + sep
      f.print I18n.t('activerecord.models.programname').capitalize + sep
      f.print I18n.t('activerecord.models.institution').capitalize + sep
      f.print I18n.t('activerecord.attributes.personalinfo.dob').capitalize + sep
      f.print I18n.t('activerecord.attributes.personalinfo.sex').capitalize + sep
      f.print ta('personalinfo.tin').capitalize + sep
      f.print ta('personalinfo.idnumber').capitalize + sep
      f.print ta('personalinfo.socialsecuritynumber').capitalize + sep
      f.print ta('personalinfo.mothersname').capitalize + sep
      f.print 'ID ' + I18n.t('activerecord.models.registration').capitalize + sep
      f.print ta('registration.accreditation.start').capitalize + sep
      f.print ta('accreditation.comment').capitalize + sep

      f.print ta('student.previouscode').capitalize

      f.puts

      @filtered_registrations.each_with_index do |registration, i|
        f.print (i + 1).to_s + sep
        f.print registration.student_name + sep
        f.print registration.student.contact.email + sep
        f.print registration.programyear.to_s + sep
        f.print registration.program_name + sep
        f.print registration.institution + sep
        f.print I18n.l(registration.student.contact.personalinfo.dob) + sep
        f.print registration.student.contact.personalinfo.sex + sep
        f.print registration.student.contact.personalinfo.tin + sep
        f.print registration.student.contact.personalinfo.idnumber + sep

        f.print registration.student.contact.personalinfo.socialsecuritynumber + sep
        f.print registration.student.contact.personalinfo.mothersname + sep
        f.print registration.id.to_s + sep
        f.print I18n.l(registration.accreditation.start) + sep

        if registration.accreditation.comment.present?

          f.print registration.accreditation.comment

        end

        f.print sep

        f.puts registration.student.previouscode
      end

      f.puts

      u = current_user

      if is_pap_staff(u)

        f.puts I18n.t('activerecord.attributes.programname.pap')

      end

      if is_medres_staff(u)

        f.puts I18n.t('activerecord.attributes.programname.medres')

      end

      f.puts

      f.puts u.contact_name

      f.puts

      f.puts I18n.l(Time.zone.now).to_s

      f.close
    end
  end

  private

  # Verify if record was edited
  def check_log
    unless @registration.versions.last.nil? # it could have been seeded in which case we must test for nil

      @userid = @registration.versions.last.whodunnit

      @user = if !@userid.nil?

                User.where(id: @userid).first

              end
      end
  end

  def set_registration_date
    @first_day_of_classes = Schoolterm.latest.start # This assumes the appropriate schoolterm has been created !!

    @today = Date.today

    if @today < @first_day_of_classes

      @registration.accreditation.start = @first_day_of_classes

      @registration_date = @first_day_of_classes

    else

      @registration_date = @today

    end

    @registration.accreditation.start = @registration_date
  end

  # Compute actual absences for registration
  def calculate_actual_absences_total_for(registration)
    Event.with_actual_absences_for(registration).absences_total
  end

  # http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records
  def set_schoolterm
    @registration.schoolterm_id = Schoolterm.open.first.id

    #       if Schoolyear.done?
    #       flash[:warning] = "Não é possível remover uma folha já concluída."

    #       end
  end

  # Applies to managers only
  def set_sector
    @registration.pap = true if is_pap_manager(current_user)

    @registration.medres = true if is_medres_manager(current_user)
  end

  # Training
  def set_confirmation_status_for_creation
    if is_local_admin(current_user)

      # 		    @registration.accreditation.confirmed=false

      @registration.accreditation.confirmed = if @registration.upcoming? # registration season

                                                true

                                              else

                                                false

                                              end

      @registration.accreditation.suspended = false # Added for completeness, to pass validation

    end
  end

  def set_confirmation_status_for_update
    if is_local_admin(current_user)

      @registration.accreditation.confirmed = false

      @registration.accreditation.suspended = false # Added for completeness, to pass validation

    end
  end

  def set_current_schoolyears
    #        @all_schoolyears=Schoolyear.includes(program: :programname).includes(program: :schoolterm)

    @user_institution_id = @registration.student.contact.user.institution_id

    if @user_institution_id.present?

      inst = Institution.find @user_institution_id

      @all_schoolyears = Schoolyear.includes(program: :programname).includes(program: :schoolterm).from_institution(inst)

    else

      @all_schoolyears = Schoolyear.includes(program: :programname).includes(program: :schoolterm)

    end

    @current_schoolyears = @all_schoolyears.present.ordered_by_programname_and_year
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_registration
    @registration = Registration.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def registration_params
    params.require(:registration).permit(:id, :supportingdocumentation, :remove_supportingdocumentation, :supportingdocumentation_cache, :remote_supportingdocumentation_url, :pap, :medres, :student_id, :schoolyear_id, :returned, :finalgrade, accreditation_attributes: %i[id renewed start comment institution_id renewal suspension original suspended revocation revoked confirmed], registrationkind_attributes: %i[id regular makeup repeat], completion_attributes: %i[id inprogress pass failure mustmakeup dnf])
    #  params.require(:registration).permit!
  end
end
