# frozen_string_literal: true

# Admission information is provided by the institutions
class Admission < ActiveRecord::Base
  belongs_to :program

  # ------------------- References ------------------------

  #   belongs_to :user

  #   has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  has_paper_trail

  # TDD

  selection_process_dates = %i[start finish]

  validate :start_date_cannot_be_in_the_future

  def info
    I18n.t('activerecord.models.admission').capitalize + ' ' + \
      I18n.t('start') + ' [' + id.to_s + '] ' + start_i18n + ' ' + I18n.l(start)
  end

  def start_date_cannot_be_in_the_future
    errors.add(:start, :may_not_be_in_the_future) if start.present? && start > Time.zone.today
  end

  validate :finish_cannot_be_more_recent_than_start

  def finish_cannot_be_more_recent_than_start
    (return unless start.present? && finish.present? && finish < start)
    errors.add(:finish, :may_not_be_more_recent_than_start)
  end

  available_grants = %i[accreditedgrants grantsasked grantsgiven]

  validate :grants_given_less_than_or_equal_to_accredited

  def grants_given_less_than_or_equal_to_accredited
    (return if grants_given_less_than_or_equal_to_accredited?)
    errors.add(:grantsgiven, :more_than_accredited)
  end

  validate :grants_asked_may_not_exceed_accredited

  def grants_asked_may_not_exceed_accredited
    (return if grants_asked_consistent_with_accredited?)
    errors.add(:grantsasked, :may_not_exceed_accredited)
  end

  candidate_stats = %i[candidates absentfirstexam passedfirstexam
                       absentfinalexam insufficientfinalexamgrade convoked admitted]

  #  validate :passed_first_exam_can_not_be_over_exam_takers

  #  def passed_first_exam_can_not_be_over_exam_takers
  #    if passedfirstexam.present? && candidates.present? \
  #       && absentfirstexam.present? && passedfirstexam + absentfirstexam > candidates
  #      errors.add(:passedfirstexam, :may_not_exceed_exam_takers)
  #    end
  #  end

  # --- Marcelo ---
  # Deactivated on 4-July-17
  # On user review the logic was found to be reversed
  #  validate :candidates_can_not_exceed_grants_given

  #  def candidates_can_not_exceed_grants_given
  #    unless candidates_grants_given_consistent?
  #      errors.add(:candidates, :may_not_exceed_grants_given)
  #    end
  #  end

  validate :convoked_can_not_be_over_admitted

  def convoked_can_not_be_over_admitted
    errors.add(:convoked, :may_not_exceed_admitted) if convoked_more_than_admitted?
  end

  validate :absences_on_first_exam_can_not_exceed_candidates

  def absences_on_first_exam_can_not_exceed_candidates
    (return if candidate_absences_on_first_exam_consistent?)
    errors.add(:absentfirstexam, :may_not_exceed_candidates)
    errors.add(:candidates, :inconsistent)
  end

  validate :passed_first_exam_can_not_exceed_takers

  def passed_first_exam_can_not_exceed_takers
    errors.add(:passedfirstexam, :may_not_exceed_takers) unless passed_first_exam_consistent?
  end

  #  Admission creation is blocked if passedfirstexam > firstexamtakers (candidates-absences)

  appeals = %i[appealsgrantedfirstexam appealsgrantedfinalexam
               appealsdeniedfirstexam appealsdeniedfinalexam]

  required_fields = selection_process_dates + available_grants + candidate_stats + appeals

  required_fields.each do |field|
    validates field, presence: true
  end

  validate :appeals_consistent_with_first_exam_failures

  def appeals_consistent_with_first_exam_failures
    (return if appeals_lodged_because_of_first_exam_failures_consistent?)
    errors.add(:appealsdeniedfirstexam, :inconsistent_with_first_exam_failures)
    errors.add(:appealsgrantedfirstexam, :inconsistent_with_first_exam_failures)
    errors.add(:insufficientfinalexamgrade, :inconsistent)
  end

  validate :appeals_consistent_with_final_exam_failures

  def appeals_consistent_with_final_exam_failures
    (return if appeals_lodged_because_of_final_exam_failures_consistent?)
    errors.add(:appealsdeniedfinalexam, :inconsistent_with_final_exam_failures)
    errors.add(:appealsgrantedfinalexam, :inconsistent_with_final_exam_failures)
    errors.add(:insufficientfinalexamgrade, :inconsistent)
  end

  validate :admitted_consistent_with_final_exam_results

  def admitted_consistent_with_final_exam_results
    (return if admitted_consistent_with_final_exam_results?)
    errors.add(:admitted, :inconsistent_with_final_exam_results)
    errors.add(:absentfinalexam, :inconsistent)
    errors.add(:insufficientfinalexamgrade, :inconsistent)
    errors.add(:passedfirstexam, :inconsistent)
  end

  # Schoolterm
  def self.ordered_by_schoolterm_desc_programname_institution
    joins(program: :programname).joins(program: :schoolterm)
                                .joins(program: :institution)
                                .order('schoolterms.start DESC, programnames.name')
  end

  # --- TDD start

  def details
    sep = ';' # separator
    txt = I18n.t('activerecord.attributes.admission.
      accreditedgrants') + ': ' + accreditedgrants.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.
      grantsasked') + ': ' + grantsasked.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.
      grantsgiven') + ': ' + grantsgiven.to_s + sep + ' '
    #    txt += I18n.t('activerecord.attributes.admission.candidates')
    # + ': ' + admission.candidates.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.
      candidates') + ': ' + candidates.to_s

    txt
  end
  # /////////////////// Antecedents \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  # Antecedents (attributes which logically came before it)
  # First: accreditedgrants
  # Second: grantsasked

  def grants_given_less_than_or_equal_to_accredited?
    accredited_grants = accreditedgrants
    grants_given = grantsgiven

    (accreditedgrants.present? && grants_given.present? && (grants_given <= accredited_grants))
  end

  # ///////////////////|||||||||||||| \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  def grants_given_consistent_with_asked?
    (grantsasked.present? && grantsgiven.present? && grantsgiven <= grantsasked)
  end

  def grants_asked_consistent_with_accredited?
    (grantsasked.present? && accreditedgrants.present? && grantsasked <= accreditedgrants)
  end

  def candidates_grants_given_consistent?
    (candidates.present? && grantsgiven.present? && candidates <= grantsgiven)
  end

  # i.e. Is the number of candidates consistent with respect to the grants
  def candidate_absences_on_first_exam_consistent?
    (candidates.present? && absentfirstexam.present? && absentfirstexam <= candidates)
  end

  def passed_first_exam_consistent?
    (passedfirstexam.present? && firstexamtakers.present? && passedfirstexam <= firstexamtakers)
  end

  def convoked_consistent_with_admitted?
    (convoked.present? && admitted.present? && admitted <= convoked)
  end

  def convoked_more_than_admitted?
    (convoked.present? && admitted.present? && convoked > admitted)
  end

  def appeals_lodged_because_of_first_exam_failures_consistent?
    appeals_lodged = appealslodgedfirstexam # already checks for nil

    exam_failures = failedfirstexam

    (exam_failures.present? && appeals_lodged <= exam_failures)
  end

  def appeals_lodged_because_of_final_exam_failures_consistent?
    appeals_lodged = appealslodgedfinalexam # already checks for nil

    exam_failures = failedfinalexam

    (exam_failures.present? && appeals_lodged <= exam_failures)
  end

  # To do: review this
  def admitted_consistent_with_final_exam_results?
    passed_first_exam = passedfirstexam
    absent_final_exam = absentfinalexam
    failed_final_exam = failedfinalexam

    (passed_first_exam.present? && absent_final_exam.present? && failed_final_exam.present? \
      && admitted.present? &&  \
      (admitted == passed_first_exam - (absent_final_exam + failed_final_exam)))
  end

  def firstexamtakers
    result = 0

    result = candidates - absentfirstexam if candidates.present? && absentfirstexam.present?

    result
  end

  def passedfinalexam
    convoked
  end

  def failedfinalexam
    insufficientfinalexamgrade
  end

  def finalexamtakers
    result = 0

    if passedfinalexam.present? && insufficientfinalexamgrade.present?

      result = passedfinalexam + insufficientfinalexamgrade

    end

    result
  end

  def failedfirstexam
    failed_first_exam = 0

    fields_present = candidates.present? && absentfirstexam.present? && passedfirstexam.present?

    failed_first_exam = candidates - absentfirstexam - passedfirstexam if fields_present

    failed_first_exam
  end

  def appealslodgedfirstexam
    appeals_lodged_first_exam = 0

    fields_present = appealsgrantedfirstexam.present? && appealsdeniedfirstexam.present?

    appeals_lodged_first_exam = appealsgrantedfirstexam + appealsdeniedfirstexam if fields_present

    appeals_lodged_first_exam
  end

  def appealslodgedfinalexam
    appeals_lodged_final_exam = 0

    fields_present = appealsgrantedfinalexam.present? && appealsdeniedfinalexam.present?

    appeals_lodged_final_exam = appealsgrantedfinalexam + appealsdeniedfinalexam if fields_present

    appeals_lodged_final_exam
  end

  # --- TDD finish

  # New for June 2017 - Admissions period
  def self.within_data_entry_period
    joins(program: :schoolterm).merge(Schoolterm.within_admissions_data_entry_period)
  end
  # From schoolyear (old version )

  # [:grantsrequested, :grants, :scholarships, :maxenrollment].each do |n|
  #    validates n, numericality: { only_integer: true, greater_than_or_equal_to: 0}, presence: true
  #  end

  # [:candidates, :approved].each do |c|
  #   validates c, numericality: { only_integer: true, greater_than_or_equal_to: 0},
  #                presence: true, :if => :first_year?

  #   end
end
