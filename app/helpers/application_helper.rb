# frozen_string_literal: true

# Review in progress - January 2020
module ApplicationHelper
  #   def yes_no(boolean)
  #   #  boolean ? t('yes').capitalize : t('no').capitalize
  #     if boolean==true
  #         I18n.t('yes').html_safe
  #        "Sim"
  #     else
  #         I18n.t('no').html_safe
  #     end
  #
  #   end

  # Display number of absences for a registration during a payroll (if applicable)
  def display_num_absences(registration, payroll)
    Annotation.num_absences_txt(registration, payroll)
  end

  # i.e. Open for local admins to enter their monthly information
  def start_of_pap_payroll_cycle?
    (Time.zone.today.day >= Settings.payroll_cycle_opening_day_for_local_admins.pap) || \
      (Time.zone.today.day < Settings.payroll_cycle_closing_day_for_local_admins.pap)
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

    Logic.within?(start, finish, Time.zone.now)
  end

  def registration_season?
    d = Time.zone.today

    (d >= Settings.registration_season.start && d <= Settings.registration_season.finish)
  end

  # Returns a title on a per-page basis.
  def display_page_info(title)
    generic_title = t('application_title')
    "#{generic_title} | #{title}"
  end

  def pluraltitle(text)
    safe_join([text.pluralize.titleize])
  end

  # -----------------------------
  # Originaly created for use in assignments (supervisors, programs)
  # Also used in Assesments (quality)
  def retrieve_programs_for(user)
    status = if permission_for(user) == 'admin' then Program.all
             elsif permission_for(user).in?(%w[papcollaborator papmgr]) then Program.pap
             elsif permission_for(user).in?(%w[medrescollaborator medresmgr]) then Program.medres
             elsif permission_for(user) == 'paplocaladm' then Program
               .from_own_institution(current_user).pap
             elsif permission_for(user) == 'medreslocaladm' then Program
               .from_own_institution(current_user).medres
             else t('undefined_value')
             end

    safe_join([status])
  end

  def accreditation_status(accr)
    status = if accr.original? then ta('accreditation.original')
              elsif accr.was_renewed? then ta('accreditation.renewed')
             elsif accr.was_suspended? then ta('accreditation.suspended')
             elsif accr.was_revoked? then ta('accreditation.revoked')
             else t('undefined_value')
             end

    safe_join([status])
  end
end
