class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper ApplicationpermissionsHelper
  helper ApplicationdisplayHelper
  helper ApplicationnavigationHelper

  protect_from_forgery with: :exception

  #http://stackoverflow.com/questions/17450185/forbidden-attributes-error-in-rails-4-when-encountering-a-situation-where-one-wo

  # Added in March 2022 due to Rails 5.0.7 upgrade (to fix a warning)
  # "PaperTrail no longer adds the set_paper_trail_whodunnit callback for you"
  # https://github.com/paper-trail-gem/paper_trail#4a-finding-out-who-was-responsible-for-a-change
  before_action :set_paper_trail_whodunnit

  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  # https://github.com/ryanb/cancan
  # 3. Handle Unauthorized Access

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # http://stackoverflow.com/questions/6792026/activerecord-deleterestrictionerror
  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    redirect_to(:back, :alert => exception.message)
  end


  # http://stackoverflow.com/questions/13434523/general-rescue-throughout-controller-when-id-not-found-ror

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def registration_season?

    d=Date.today

    return (d>=Settings.registration_season.start && d<=Settings.registration_season.finish)

  end


  def to_numeric_date(d)

    return (d-Settings.dayone).to_i

  end

  def days_for_month(m)

    return Time.days_in_month(m.month.to_i, m.year.to_i+1) # Needed +1 in 2016 to account for leap year.

  end

  def record_not_found
    redirect_to action: :index
  end

  def is_pap_staff(user)

    if user.permission.kind.in?(['paplocaladm','papmgr'])

      return true

    else

      return false
    end

  end

  # Shorthand method for translating activerecord models
  def tm(modelname)

    prefix="activerecord.models."
    text=prefix+modelname
    return t(text)

  end

  # Important: collaborators are not considered staff!
  # These two helpers are currently used in the programsituation controller

  def is_medres_collaborator(user)

    if user.permission.kind=='medrescollaborator'

      return true

    else

      return false
    end

  end

  def is_pap_collaborator(user)

    if user.permission.kind=='papcollaborator'

      return true

    else

      return false
    end

  end


  def first_of_month?(date_value)

    return date_value==date_value.beginning_of_month

  end
  # -----------------------------------------------------------

  def is_medres_staff(user)

    if user.permission.kind.in?(['medreslocaladm','medresmgr'])

      return true

    else

      return false
    end

  end

  def is_collaborator(user)

    if user.permission.kind.in?(['medrescollaborator','collaborator'])

      return true

    else

      return false
    end

  end


  def is_staff(user)

    return is_not_regular_user(user)

  end

  # Hotfix - user creation
  def is_manager(user)

    return ( is_pap_manager(user) || is_medres_manager(user) )

  end

  def is_medres_manager(user)

    if permission_for(user)=='medresmgr'

      return true

    else return false

    end

  end

  def is_pap_manager(user)

    if permission_for(user)=='papmgr'

      return true

    else return false

    end

  end

  def is_regular_user(user)

    if user.permission.kind.in?(['pap','medres','papcollaborator','medrescollaborator'])

      return true

    else

      return false
    end

  end

  def is_not_admin(user)

    if user.permission.kind!='admin'

      return true

    else

      return false
    end

  end

  def is_admin(user)

    if user.permission.kind=='admin'

      return true

    else

      return false
    end

  end

  def is_local_admin(user)

    if (user.permission.kind=='paplocaladm' || user.permission.kind=='medreslocaladm')

      return true

    else

      return false
    end

  end


  def is_not_regular_user(user)

    if user.permission.kind.in?(['admin', 'adminreadonly', 'papmgr','medresmgr','paplocaladm','medreslocaladm'])

      return true

    else

      return false
    end

  end

  def is_admin_or_readonly(user)

    if user.permission.kind.in?(['admin', 'adminreadonly'])

      return true

    else

      return false
    end

  end

  # Includes read only
  def is_admin_or_manager(user)

    if user.permission.kind.in?(['admin', 'adminreadonly','papmgr','medresmgr'])

      return true

    else

      return false

    end

  end

  # Refer to: users controller, create contact
  def is_local(user)

    return (is_local_admin(user) || is_regular_user(user))

  end

  # Headquarters, i.e. Managers and Admins
  def hq(user)

    return !is_local(user)

  end

  def permission_for(user)

    return user.permission.kind

  end

  # New for 2017 - Payroll reports

  def set_payroll

    @payroll = Payroll.find(params[:payroll_id])

  end

  def set_report_variables

    @all_annotations=Annotation.includes(registration: [student: [contact: {user: :institution}]])
    @all_events=Event.includes(:leavetype).includes(:registration) # used in report_annotations view (bullet)
    @all_institutions=Institution.all
    @all_registrations=Registration.all
    @scholarship_for_payroll=Scholarship.in_effect_for(@payroll)

    @payroll_annotations=@all_annotations.for_payroll(@payroll)

    # Marcelo - Added 7 - 7 - 17

    @payroll_events=@all_events.for_payroll(@payroll)
    @num_payroll_events=@payroll_events.count

    if !is_admin_or_manager(current_user)

      @payroll_annotations=@payroll_annotations.for_institution(current_user.institution)

    end

    @num_payroll_annotations=@payroll_annotations.count

  end

end
