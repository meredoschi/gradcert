class Admission < ActiveRecord::Base
  belongs_to :program

  # ------------------- References ------------------------

  # 	belongs_to :user

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  has_paper_trail

  # TDD

  selection_process_dates = %i[start finish]

  validate :start_date_cannot_be_in_the_future

  def info
    admission_i18n = I18n.t('activerecord.models.admission').capitalize
    start_i18n = I18n.t('start')

    adm_details = admission_i18n + ' ' + start_i18n
    adm_details += ' [' + id.to_s + '] ' + start_i18n
    adm_details += ' ' + I18n.l(start)
  end

  def start_date_cannot_be_in_the_future
    if start.present? && start > Date.today
      errors.add(:start, :may_not_be_in_the_future)
    end
  end

  validate :finish_cannot_be_more_recent_than_start

  def finish_cannot_be_more_recent_than_start
    if start.present? && finish.present? && finish < start
      errors.add(:finish, :may_not_be_more_recent_than_start)
    end
  end

  available_grants = %i[accreditedgrants grantsasked grantsgiven]

  validate :grants_given_less_than_or_equal_to_accredited

  def grants_given_less_than_or_equal_to_accredited
    unless grants_given_less_than_or_equal_to_accredited?
      errors.add(:grantsgiven, :more_than_accredited)
    end
  end

  validate :grants_asked_may_not_exceed_accredited

  def grants_asked_may_not_exceed_accredited
    unless grants_asked_consistent_with_accredited?
      errors.add(:grantsasked, :may_not_exceed_accredited)
    end
  end

  candidate_stats = %i[candidates absentfirstexam passedfirstexam absentfinalexam insufficientfinalexamgrade convoked admitted]

  #  validate :passed_first_exam_can_not_be_over_exam_takers

  #  def passed_first_exam_can_not_be_over_exam_takers
  #    if passedfirstexam.present? && candidates.present? && absentfirstexam.present? && passedfirstexam + absentfirstexam > candidates
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
    if convoked_more_than_admitted?
      errors.add(:convoked, :may_not_exceed_admitted)
    end
  end

  validate :absences_on_first_exam_can_not_exceed_candidates

  def absences_on_first_exam_can_not_exceed_candidates
    unless candidate_absences_on_first_exam_consistent?
      errors.add(:absentfirstexam, :may_not_exceed_candidates)
      errors.add(:candidates, :inconsistent)
    end
  end

  validate :passed_first_exam_can_not_exceed_takers

  def passed_first_exam_can_not_exceed_takers
    unless passed_first_exam_consistent?
      errors.add(:passedfirstexam, :may_not_exceed_takers)
    end
  end

  #  Admission creation is blocked if passedfirstexam > firstexamtakers (candidates-absences)

  appeals = %i[appealsgrantedfirstexam appealsgrantedfinalexam appealsdeniedfirstexam appealsdeniedfinalexam]

  required_fields = selection_process_dates + available_grants + candidate_stats + appeals

  required_fields.each do |field|
    validates field, presence: true
  end

  validate :appeals_consistent_with_first_exam_failures

  def appeals_consistent_with_first_exam_failures
    unless appeals_lodged_because_of_first_exam_failures_consistent?
      errors.add(:appealsdeniedfirstexam, :inconsistent_with_first_exam_failures)
      errors.add(:appealsgrantedfirstexam, :inconsistent_with_first_exam_failures)
      errors.add(:insufficientfinalexamgrade, :inconsistent)
    end
  end

  validate :appeals_consistent_with_final_exam_failures

  def appeals_consistent_with_final_exam_failures
    unless appeals_lodged_because_of_final_exam_failures_consistent?
      errors.add(:appealsdeniedfinalexam, :inconsistent_with_final_exam_failures)
      errors.add(:appealsgrantedfinalexam, :inconsistent_with_final_exam_failures)
      errors.add(:insufficientfinalexamgrade, :inconsistent)
    end
  end

  validate :admitted_consistent_with_final_exam_results

  def admitted_consistent_with_final_exam_results
    unless admitted_consistent_with_final_exam_results?
      errors.add(:admitted, :inconsistent_with_final_exam_results)
      errors.add(:absentfinalexam, :inconsistent)
      errors.add(:insufficientfinalexamgrade, :inconsistent)
      errors.add(:passedfirstexam, :inconsistent)
    end
  end

  # Schoolterm
  def self.ordered_by_schoolterm_desc_programname_institution
    joins(program: :programname).joins(program: :schoolterm).joins(program: :institution).order('schoolterms.start DESC, programnames.name')
  end

  # --- TDD start

  def details
    sep = ';' # separator
    txt = I18n.t('activerecord.attributes.admission.accreditedgrants') + ': ' + accreditedgrants.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.grantsasked') + ': ' + grantsasked.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.grantsgiven') + ': ' + grantsgiven.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.candidates') + ': ' + candidates.to_s

    txt
  end

  # /////////////////// Antecedents \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  # Antecedents (attributes which logically came before it)
  # First: accreditedgrants
  # Second: grantsasked

  def grants_given_less_than_or_equal_to_accredited?
    accredited_grants = accreditedgrants
    grants_given = grantsgiven

    status = if accreditedgrants.present? && grants_given.present? && (grants_given <= accredited_grants)

               true

             else

               false

    end

    status
  end

  # ///////////////////|||||||||||||| \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  def grants_given_consistent_with_asked?
    status = if grantsasked.present? && grantsgiven.present? && grantsgiven <= grantsasked

               true

             else

               false

    end

    status
  end

  def grants_asked_consistent_with_accredited?
    situation = if grantsasked.present? && accreditedgrants.present? && grantsasked <= accreditedgrants
                  true
                else
                  false
    end

    situation
  end

  def candidates_grants_given_consistent?
    status = if candidates.present? && grantsgiven.present? && candidates <= grantsgiven

               true

             else

               false

    end

    status
  end

  # i.e. Is the number of candidates consistent with respect to the grants
  def candidate_absences_on_first_exam_consistent?
    status = if candidates.present? && absentfirstexam.present? && absentfirstexam <= candidates

               true

             else

               false

    end

    status
  end

  def passed_first_exam_consistent?
    status = if passedfirstexam.present? && firstexamtakers.present? && passedfirstexam <= firstexamtakers

               true

             else

               false

    end

    status
  end

  def convoked_consistent_with_admitted?
    status = if convoked.present? && admitted.present? && admitted <= convoked

               true

             else

               false

    end

    status
  end

  def convoked_more_than_admitted?
    status = if convoked.present? && admitted.present? && convoked > admitted

               true

             else

               false

    end

    status
  end

  def appeals_lodged_because_of_first_exam_failures_consistent?
    appeals_lodged = appealslodgedfirstexam # already checks for nil

    exam_failures = failedfirstexam

    status = if exam_failures.present? && appeals_lodged <= exam_failures

               true

             else

               false

    end
  end

  def appeals_lodged_because_of_final_exam_failures_consistent?
    appeals_lodged = appealslodgedfinalexam # already checks for nil

    exam_failures = failedfinalexam

    status = if exam_failures.present? && appeals_lodged <= exam_failures

               true

             else

               false

    end
  end

  # To do: review this
  def admitted_consistent_with_final_exam_results?
    passed_first_exam = passedfirstexam
    absent_final_exam = absentfinalexam
    failed_final_exam = failedfinalexam

    status = if passed_first_exam.present? && absent_final_exam.present? && failed_final_exam.present? && admitted.present? && (admitted == passed_first_exam - (absent_final_exam + failed_final_exam))

               true

             else

               false

    end

    status
  end

  def firstexamtakers
    @result = 0

    if candidates.present? && absentfirstexam.present?

      @result = candidates - absentfirstexam

    end

    @result
  end

  def passedfinalexam
    convoked
  end

  def failedfinalexam
    insufficientfinalexamgrade
  end

  def finalexamtakers
    @result = 0

    if passedfinalexam.present? && insufficientfinalexamgrade.present?

      @result = passedfinalexam + insufficientfinalexamgrade

    end

    @result
  end

  def failedfirstexam
    @failed_first_exam = 0

    fields_present = candidates.present? && absentfirstexam.present? && passedfirstexam.present?

    if fields_present

      @failed_first_exam = candidates - absentfirstexam - passedfirstexam

    end

    @failed_first_exam
  end

  def appealslodgedfirstexam
    @appeals_lodged_first_exam = 0

    fields_present = appealsgrantedfirstexam.present? && appealsdeniedfirstexam.present?

    if fields_present

      @appeals_lodged_first_exam = appealsgrantedfirstexam + appealsdeniedfirstexam

    end

    @appeals_lodged_first_exam
  end

  def appealslodgedfinalexam
    @appeals_lodged_final_exam = 0

    fields_present = appealsgrantedfinalexam.present? && appealsdeniedfinalexam.present?

    if fields_present

      @appeals_lodged_final_exam = appealsgrantedfinalexam + appealsdeniedfinalexam

    end

    @appeals_lodged_final_exam
  end

  # --- TDD finish

  #

  # New for June 2017 - Admissions period
  def self.within_data_entry_period
    joins(program: :schoolterm).merge(Schoolterm.within_admissions_data_entry_period)
  end
  # From schoolyear (old version )

  # [:grantsrequested, :grants, :scholarships, :maxenrollment].each do |n|
  #  	validates n, numericality: { only_integer: true, greater_than_or_equal_to: 0}, presence: true
  #	end

  # [:candidates, :approved].each do |c|
  # 	validates c, numericality: { only_integer: true, greater_than_or_equal_to: 0}, presence: true, :if => :first_year?

  # 	end
end
