module ApplicationHelper

=begin
  def yes_no(boolean)
  #  boolean ? t('yes').capitalize : t('no').capitalize
    if boolean==true
        I18n.t('yes').html_safe
#        "Sim"
    else
        I18n.t('no').html_safe
    end

  end
=end

  # Display number of absences for a registration during a payroll (includes none)
  def display_number_absences_for_registration_on_payroll(r, p)
    num_absences = Annotation.num_absences_for_registration_on_payroll(r, p)

    absences_label = ta('event.absence').pluralize(num_absences).downcase

    if num_absences > 0

      return num_absences.to_s + ' ' + absences_label.html_safe

    else

      return t('no_absences').capitalize

   end
  end

  def places_available?(user)
    Placesavailable.where(institution_id: user.institution_id, schoolterm_id: Schoolterm.latest, allowregistrations: true).exists?
  end

  # i.e. Open for local admins to enter their monthly information
  def start_of_pap_payroll_cycle?
    (Date.today.day >= Settings.payroll_cycle_opening_day_for_local_admins.pap) || (Date.today.day < Settings.payroll_cycle_closing_day_for_local_admins.pap)
  end

  def open_season?
    Schoolterm.open_season?
  end

  # From ability.rb - New for May 2017
  def data_entry_permitted_on_latest_payroll?
    latest_payroll = Payroll.actual.latest.first

    latest_payroll.dataentrypermitted?
  end

  # New for 2017
  def registrations_permitted?
    start = Settings.registration_season.start

    finish = Settings.registration_season.finish

    Logic.within?(start, finish, Time.now)
  end

  def registration_season?
    d = Date.today

    (d >= Settings.registration_season.start && d <= Settings.registration_season.finish)
  end

  # Returns a title on a per-page basis.
  def title
    base_title = t('application_title')

    if @title.nil?
      base_title
    else
      #       "#{base_title} | #{@title}"
      @title
    end
  end

  def pluraltitle(text)
    text.pluralize.titleize.html_safe
  end

  # -----------------------------
  # Originaly created for use in assignments (supervisors, programs)
  # Also used in Assesments (quality)
  def retrieve_programs_for(user)

    status = case

    when permission_for(user) == 'admin' then Program.all
    when permission_for(user) == 'papmgr' || 'papcollaborator' then  Program.pap
    when permission_for(user) == 'medresmgr' || 'medrescollaborator' then  Program.medres
    when permission_for(user) == 'paplocaladm' then  Program.from_own_institution(current_user).pap
    when permission_for(user) == 'medreslocaladm' then  Program.from_own_institution(current_user).medres
    else t('undefined_value')
    end

    return status.html_safe

  end

  def accreditation_status(accr)

    status = case

    when accr.is_original? then ta('accreditation.original')
    when accr.was_renewed? then ta('accreditation.renewed')
    when accr.was_suspended? then ta('accreditation.suspended')
    when accr.was_revoked? then ta('accreditation.revoked')
    else t('undefined_value')
    end

    return status.html_safe

  end
end
