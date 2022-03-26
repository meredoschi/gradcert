class AbsentreportsController < ApplicationController

  before_action :authenticate_user! # By default... Devise

  def show
    set_payroll
    set_report_variables # from applications controller

    @title=I18n.t('payroll_absences_report')

# new
#    @actual_absence_events=@all_events.for_payroll(@payroll).actual_absence.ordered_by_contact_name

    @absence_events=@all_events.for_payroll(@payroll).absence.ordered_by_contact_name

#    @registration_ids_with_absences=@actual_absence_events.pluck("registrations.id")

    @registration_ids_with_absences=@absence_events.pluck("registrations.id")

    @registrations_with_absences=@all_registrations.where(id: @registration_ids_with_absences).includes(schoolyear: [program: :schoolterm]).includes(schoolyear: [program: :programname]).includes(student: :contact).ordered_by_institution_and_name

    @institution_ids_array=@registrations_with_absences.pluck("institutions.id")

    @unique_institution_ids=@institution_ids_array.uniq

    @institution_indices=[]

    @unique_institution_ids.each do |id|

      @institution_indices << @institution_ids_array.find_index { |x| x==id}

    end

# ----

=begin

    @institution_absences=0

    @absences_grand_total=0

    @active_registrations=@all_registrations.accessible_by(current_ability).current.regular_for_payroll(@payroll).not_cancelled_during_payroll(@payroll) # Filter out registrations cancelled (obviously during this payroll)
    @institutions_with_absences=@active_registrations.institutions

    @absences_list=[]
    @absent_registration_ids=[]

    @active_registrations.ordered_by_institution_and_name.each do |registration|

      num_absences=@all_events.actual_absences_for(registration)

      if num_absences>0

        @absent_student_info={institution_id: registration.institution_id, registration_id: registration.id, total_absences: num_absences}
        @absences_list << @absent_student_info

      end

    end


    @absences_list.sort_by!{ |hsh| hsh[:institution_id]} # http://stackoverflow.com/questions/5483889/how-to-sort-an-array-of-hashes-in-ruby

    @absent_registration_ids=@absences_list.map{|x| x[:registration_id]}

    @absent_registrations=@active_registrations.ordered_by_institution_and_name.where(id: @absent_registration_ids)

    @num_absent_registrations=@absent_registrations.count

    @absent_institution_ids=@absent_registrations.institution_ids

=end

  end


end
