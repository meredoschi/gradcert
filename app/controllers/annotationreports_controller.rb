class AnnotationreportsController < ApplicationController

  before_filter :authenticate_user! # By default... Devise


  def show

    @title=I18n.t('payroll_annotations_report')

    set_payroll

    set_report_variables

    @institutions=@all_registrations.active_institutions # Take a look at this!

    # Eager loaded payroll annotations

    #    @eager_loaded_payroll_annotations_ordered_by_name=@payroll_annotations.includes(registration: [student: [contact: :personalinfo]]).includes(registration: [schoolyear: [program: :programname]]).includes(registration: [schoolyear: [program: :schoolterm]]).ordered_by_institution_and_contact_name


    if !is_admin_or_manager(current_user)

      @payroll_annotations=@payroll_annotations.for_institution(current_user.institution)
      @num_payroll_annotations=@payroll_annotations.count

    end

    @eager_loaded_payroll_annotations_ordered_by_name=@payroll_annotations.includes(registration: [student: [contact: :personalinfo]]).includes(registration: [schoolyear: [program: :programname]]).includes(registration: [schoolyear: [program: :schoolterm]]).ordered_by_institution_and_contact_name

    #     @payroll_annotation_institution_ids=@payroll_annotations.pluck("institutions.id") # Returns array

    @payroll_annotation_institution_ids=@payroll_annotations.institution_ids # Returns array

    @current_institution_id=0 # nil, used for report comparisson
    # bullet

    @institution_ids_with_annotations=@payroll_annotations.institution_ids

    @institution_ids_sans_annotations=@institutions.pluck(:id)-@institution_ids_with_annotations # i.e. without annotations

    @num_institution_ids_sans_annotations=@institution_ids_sans_annotations.count

    @report_annotations=@payroll_annotations.ordered_by_contact_name

    @current_time=Time.current


  end

  def set_payroll

    @payroll = Payroll.find(params[:payroll_id])

  end

end
