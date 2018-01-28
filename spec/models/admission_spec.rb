require 'rails_helper'

RSpec.describe Admission, type: :model do
  let(:program) { FactoryBot.create(:program, :biannual) }

  let(:admission) { FactoryBot.create(:admission, :zero_amounts) }

  #  selection_process_dates

  it { is_expected.to validate_presence_of(:start) }
  it { is_expected.to validate_presence_of(:finish) }

  #  available_grants

  it { is_expected.to validate_presence_of(:accreditedgrants) }
  it { is_expected.to validate_presence_of(:grantsasked) }
  it { is_expected.to validate_presence_of(:grantsgiven) }

  #  candidate_stats

  it { is_expected.to validate_presence_of(:candidates) }
  it { is_expected.to validate_presence_of(:absentfirstexam) }
  it { is_expected.to validate_presence_of(:passedfirstexam) }
  it { is_expected.to validate_presence_of(:absentfinalexam) }
  it { is_expected.to validate_presence_of(:insufficientfinalexamgrade) }
  it { is_expected.to validate_presence_of(:convoked) }
  it { is_expected.to validate_presence_of(:admitted) }

  #  appeals

  it { is_expected.to validate_presence_of(:appealsgrantedfirstexam) }
  it { is_expected.to validate_presence_of(:appealsdeniedfirstexam) }
  it { is_expected.to validate_presence_of(:appealsgrantedfinalexam) }
  it { is_expected.to validate_presence_of(:appealsdeniedfinalexam) }

  # Multiple consistency

  # Antecedents (attributes which logically came before it)
  # First: accreditedgrants
  # Second: grantsasked

  def grants_given_less_than_or_equal_to_accredited?
    accredited_grants = admission.accreditedgrants
    grants_given = admission.grantsgiven

    fields_present = accredited_grants.present? && grants_given.present?

    sequentially_decreasing_or_equal = (grants_given <= accredited_grants)

    status = if fields_present && sequentially_decreasing_or_equal

               true

             else

               false

    end

    status
  end

  #
  # Consistency verification methods

  def grants_asked_consistent_with_accredited?
    status = if admission.grantsasked.present? && admission.accreditedgrants.present? && admission.grantsasked <= admission.accreditedgrants

               true

             else

               false

    end

    status
  end

  def grants_given_consistent_with_asked?
    status = if admission.grantsasked.present? && admission.grantsgiven.present? && admission.grantsgiven <= admission.grantsasked

               true

             else

               false

    end

    status
  end

  # i.e. Is the number of candidates consistent with respect to the grants
  def candidates_consistent_with_grants?
    status = if admission.candidates.present? && admission.grantsgiven.present? && admission.candidates <= admission.grantsgiven

               true

             else

               false

    end

    status
  end

  # i.e. Is the number of candidates consistent with respect to the grants
  def candidate_absences_on_first_exam_consistent?
    status = if admission.candidates.present? && admission.absentfirstexam.present? && admission.absentfirstexam <= admission.candidates

               true

             else

               false

    end

    status
  end

  # i.e. Is the number of candidates which passed (had a succesful grade) on the first exam in relation to test takers
  def passed_first_exam_consistent?
    status = if admission.passedfirstexam.present? && admission.firstexamtakers.present? && admission.passedfirstexam <= admission.firstexamtakers

               true

             else

               false

    end

    status
  end

  def convoked_consistent_with_admitted?
    status = if admission.convoked.present? && admission.admitted.present? && admission.convoked <= admission.admitted

               true

             else

               false

    end

    status
  end

  def convoked_more_than_admitted?
    admitted = admission.admitted
    convoked = admission.convoked

    status = if convoked.present? && admitted.present? && convoked > admitted

               true

             else

               false

    end

    status
  end

  def passed_final_exam_consistent?
    status = if admission.passedfinalexam.present? && admission.finalexamtakers.present? && admission.passedfinalexam <= admission.finalexamtakers

               true

             else

               false

    end

    status
  end

  # i.e. Given the number of people which failed this exam
  def appeals_lodged_because_of_first_exam_failures_consistent?
    appeals_lodged = admission.appealslodgedfirstexam # already checks for nil

    exam_failures = admission.failedfirstexam

    status = if exam_failures.present? appeals_lodged <= exam_failures

               true

             else

               false

    end
  end

  # i.e. Given the number of people which failed this exam
  def appeals_lodged_because_of_final_exam_failures_consistent?
    appeals_lodged = admission.appealslodgedfinalexam # already checks for nil

    exam_failures = admission.failedfinalexam

    status = if exam_failures.present? appeals_lodged <= exam_failures

               true

             else

               false

    end
  end

  #
  # To do: review this
  def admitted_consistent_with_final_exam_results?
    passed_first_exam = admission.passedfirstexam
    absent_final_exam = admission.absentfinalexam
    failed_final_exam = admission.failedfinalexam
    admitted = admission.admitted

    status = if passed_first_exam.present? && absent_final_exam.present? && failed_final_exam.present? && admitted.present? && (admitted == passed_first_exam - (absent_final_exam + failed_final_exam))

               true

             else

               false

    end

    status
  end

  # --- Consistency methods above

  it '-info' do
    admission_i18n = I18n.t('activerecord.models.admission').capitalize
    start_i18n = I18n.t('start')

    adm_details = admission_i18n + ' ' + start_i18n
    adm_details += ' [' + admission.id.to_s + '] ' + start_i18n
    adm_details += ' ' + I18n.l(admission.start)
  end

  it 'name' do
    if payroll.pending?

      @payroll_name = I18n.l(monthworked, format: :my) + ' *' + I18n.t('pending') + '*'

    else

      @payroll_name = payroll.shortname

    end

    # @payroll_name

    expect(@payroll_name).to eq(payroll.name)
  end

  it 'can be created' do
    # print I18n.t('activerecord.models.admission').capitalize + ': '

    program = FactoryBot.create(:program, :annual)

    admission = FactoryBot.create(:admission, :zero_amounts)
  end

  it '-details' do
    sep = ';' # separator
    txt = I18n.t('activerecord.attributes.admission.accreditedgrants') + ': ' + admission.accreditedgrants.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.grantsasked') + ': ' + admission.grantsasked.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.grantsgiven') + ': ' + admission.grantsgiven.to_s + sep + ' '
    #    txt += I18n.t('activerecord.attributes.admission.candidates') + ': ' + admission.candidates.to_s + sep + ' '
    txt += I18n.t('activerecord.attributes.admission.candidates') + ': ' + admission.candidates.to_s

    admission_details = txt

    expect(admission.details).to eq(admission_details)
  end

  it '-firstexamtakers (virtual attribute)' do
    first_exam_takers = admission.candidates - admission.absentfirstexam

    expect(admission.firstexamtakers).to eq first_exam_takers
  end

  it '-passedfinalexam (is a convoked alias)' do
    expect(admission.passedfinalexam).to eq(admission.convoked)
  end

  it '-failedfinalexam (is a insufficientfinalexamgrade alias)' do
    expect(admission.failedfinalexam).to eq(admission.insufficientfinalexamgrade)
  end

  it '-finalexamtakers (virtual attribute)' do
    final_exam_takers = admission.passedfinalexam + admission.insufficientfinalexamgrade

    expect(admission.finalexamtakers).to eq final_exam_takers
  end

  #  it '-candidates_consistent?' do

  #  end

  it 'admitted_consistent_with_final_exam_results? is true with valid data' do
    program_admission = FactoryBot.build(:admission, :zero_amounts, :final_exam)
    expect(program_admission.admitted_consistent_with_final_exam_results?).to be true
  end

  it 'admitted_consistent_with_final_exam_results? is false with incorrect data' do
    program_admission = FactoryBot.build(:admission, :zero_amounts, :final_exam_inconsistent)
    expect(program_admission.admitted_consistent_with_final_exam_results?).to be false
  end

  it 'creation is blocked admitted_consistent_with_final_exam_results?' do
    # print I18n.t('activerecord.models.admission').capitalize + ': '

    program = FactoryBot.create(:program, :annual)

    expect { admission = FactoryBot.create(:admission, :zero_amounts, :final_exam_inconsistent) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it '-appeals_lodged_because_of_first_exam_failures_consistent? true with valid data' do
    program_admission = FactoryBot.build(:admission, :zero_amounts, :first_exam, :appeals_consistent_with_first_exam_failures)
    # To be different from admission (from the Let)
    expect(program_admission.appeals_lodged_because_of_first_exam_failures_consistent?).to be true
  end

  it '-appeals_lodged_because_of_final_exam_failures_consistent? true with valid data' do
    program_admission = FactoryBot.build(:admission, :zero_amounts, :final_exam, :appeals_consistent_with_final_exam_failures)
    # To be different from admission (from the Let)
    expect(program_admission.appeals_lodged_because_of_final_exam_failures_consistent?).to be true
  end

  it '-grants_given_less_than_or_equal_to_accredited? true with correct data' do
    admission.accreditedgrants = 60
    admission.grantsgiven = 50
    # puts admission.details
    expect(admission.grants_given_less_than_or_equal_to_accredited?).to be true
  end

  it '-grants_given_less_than_or_equal_to_accredited? false with incorrect data' do
    admission.accreditedgrants = 40
    admission.grantsgiven = 50
    # puts admission.details
    expect(admission.grants_given_less_than_or_equal_to_accredited?).to be false
  end

  it '-appeals_lodged_because_of_first_exam_failures_consistent? false with incorrect data' do
    program_admission = FactoryBot.build(:admission, :zero_amounts, :first_exam, :appeals_inconsistent_with_first_exam_failures)
    # To be different from admission (from the Let)
    expect(program_admission.appeals_lodged_because_of_first_exam_failures_consistent?).to be false
  end

  it '-appeals_lodged_because_of_first_exam_failures_consistent? true with correct data' do
    program_admission = FactoryBot.build(:admission, :zero_amounts, :first_exam, :appeals_inconsistent_with_first_exam_failures)
    # To be different from admission (from the Let)
    expect(program_admission.appeals_lodged_because_of_first_exam_failures_consistent?).to be false
  end

  it '-candidate_absences_on_first_exam_consistent? true with valid data' do
    admission.candidates = 7

    admission.absentfirstexam = 2

    expect(admission.candidate_absences_on_first_exam_consistent?).to be true
  end

  it '-convoked_consistent_with_admitted? true with valid data' do
    program_admission = FactoryBot.create(:admission, :zero_amounts, :convoked_consistent_with_admitted)
    expect(program_admission.convoked_consistent_with_admitted?).to be true
  end

  it '-convoked_more_than_admitted? true with incorrect data' do
    admission.admitted = 40
    admission.convoked = 80

    # print "Debug: "
    # puts admission.details

    expect(admission.convoked_more_than_admitted?).to be true
  end

  it '-passed_first_exam_consistent? true with correct data' do
    admission.candidates = 7

    admission.absentfirstexam = 2

    admission.passedfirstexam = 5

    expect(admission.passed_first_exam_consistent?).to be true
  end

  it '-passed_first_exam_consistent? false with incorrect data' do
    admission.candidates = 7

    admission.absentfirstexam = 5

    admission.passedfirstexam = 3

    expect(admission.passed_first_exam_consistent?).to be false
  end

  #  pending 'block creation if finish_more_recent_than_start?' do

  #  end

  #  pending 'block creation if start_date_in_the_future' do

  #  end

  it '-candidate_absences_on_first_exam_consistent? false with incorrect data' do
    admission.candidates = 7

    admission.absentfirstexam = 9

    expect(admission.candidate_absences_on_first_exam_consistent?).to be false
  end

  it 'candidates_grants_given_consistent? true with valid data' do
    admission.candidates = 7

    admission.grantsgiven = 10

    expect(admission.candidates_grants_given_consistent?).to be true
    # puts admission.details
  end

  it 'candidates_grants_given_consistent? true with valid data' do
    admission.candidates = 7

    admission.grantsgiven = 10

    expect(admission.candidates_grants_given_consistent?).to be true
    # puts admission.details
  end

  it 'candidates_grants_given_consistent? true with valid data' do
    admission.candidates = 7

    admission.grantsgiven = 10

    expect(admission.candidates_grants_given_consistent?).to be true
    # puts admission.details
  end

  it 'grants asked should be consistent with valid data' do
    admission.accreditedgrants = 12

    admission.grantsasked = 10

    expect(admission.grants_asked_consistent_with_accredited?).to be true
  end

  it 'creation is blocked unless grants_asked_consistent?' do
    # print I18n.t('activerecord.models.admission').capitalize + ': '

    program = FactoryBot.create(:program, :annual)

    expect { admission = FactoryBot.create(:admission, :zero_amounts, :asked_more_than_accredited) }.to raise_error(ActiveRecord::RecordInvalid)
    # https://stackoverflow.com/questions/35455104/why-is-this-rspec-expect-to-raise-error-failing-when-the-message-returned-is
  end

  it 'creation is blocked unless grants_given_less_than_or_equal_to_accredited?' do
    # print I18n.t('activerecord.models.admission').capitalize + ': '

    program = FactoryBot.create(:program, :annual)

    expect { admission = FactoryBot.create(:admission, :zero_amounts, :given_more_than_accredited) }.to raise_error(ActiveRecord::RecordInvalid)
    # https://stackoverflow.com/questions/35455104/why-is-this-rspec-expect-to-raise-error-failing-when-the-message-returned-is
  end

  it 'creation is blocked if convoked_more_than_admitted?' do
    # print I18n.t('activerecord.models.admission').capitalize + ': '

    program = FactoryBot.create(:program, :annual)

    expect { admission = FactoryBot.create(:admission, :zero_amounts, :convoked_more_than_admitted) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'creation is blocked if grants given > asked' do
    #  program = FactoryBot.create(:program, :annual)
    #    admission = FactoryBot.build(:admission, :zero_amounts, :given_more_than_asked)
    expect { admission = FactoryBot.create(:admission, :zero_amounts, :given_more_than_asked) }.to raise_error(ActiveRecord::RecordInvalid)
    # https://stackoverflow.com/questions/35455104/why-is-this-rspec-expect-to-raise-error-failing-when-the-message-returned-is
  end

  # Logic condition possibly reversed - flagged during user review
  #  it 'creation is blocked if candidates > grants given' do
  #    expect { admission = FactoryBot.create(:admission, :zero_amounts, :candidates_more_than_grants_given) }.to raise_error(ActiveRecord::RecordInvalid)
  #  end

  it 'creation is blocked unless candidate_absences_on_first_exam_consistent?' do
    #    expect { admission = FactoryBot.create(:admission, :absent_first_exam_more_than_candidates) }.to raise_error(ActiveRecord::RecordInvalid, I18n.t('activerecord.errors.models.admission.attributes.absentfirstexam.may_not_exceed_candidates'))
    #   Actual error message (I18n) is longer so test was failing when custom message was applied.
    expect { admission = FactoryBot.create(:admission, :zero_amounts, :absent_first_exam_more_than_candidates) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'creation is blocked unless grants_given_consistent_with_asked?' do
    #    expect { admission = FactoryBot.create(:admission, :absent_first_exam_more_than_candidates) }.to raise_error(ActiveRecord::RecordInvalid, I18n.t('activerecord.errors.models.admission.attributes.absentfirstexam.may_not_exceed_candidates'))
    #   Actual error message (I18n) is longer so test was failing when custom message was applied.
    expect { admission = FactoryBot.create(:admission, :zero_amounts, :more_grants_given_than_asked) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'creation is blocked unless passed_first_exam_consistent?' do
    # uncomment to show detailed error message
    #  expect { admission = FactoryBot.create(:admission, :zero_amounts, :passed_first_exam_inconsistent)}.to raise_error(ActiveRecord::RecordInvalid,'A')
    expect { admission = FactoryBot.create(:admission, :zero_amounts, :passed_first_exam_inconsistent) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'creation is blocked unless appeals_lodged_because_of_first_exam_failures_consistent?' do
    # uncomment to show detailed error message
    #  expect { admission = FactoryBot.create(:admission, :zero_amounts, :passed_first_exam_inconsistent)}.to raise_error(ActiveRecord::RecordInvalid,'A')
    expect { admission = FactoryBot.create(:admission, :zero_amounts, :appeals_inconsistent_with_first_exam_failures) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'creation is blocked unless appeals_lodged_because_of_final_exam_failures_consistent?' do
    # uncomment to show detailed error message
    #  expect { admission = FactoryBot.create(:admission, :zero_amounts, :passed_final_exam_inconsistent)}.to raise_error(ActiveRecord::RecordInvalid,'A')
    expect { admission = FactoryBot.create(:admission, :zero_amounts, :appeals_inconsistent_with_final_exam_failures) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it '-firstexamtakers' do
    @first_exam_takers = 0

    if admission.candidates.present? && admission.absentfirstexam.present?

      @first_exam_takers = admission.candidates - admission.absentfirstexam

    end

    expect(admission.firstexamtakers).to eq @first_exam_takers
  end

  it '-failedfirstexam' do
    @failed_first_exam = 0

    candidates = admission.candidates
    absentfirstexam = admission.absentfirstexam
    passedfirstexam = admission.passedfirstexam

    fields_present = candidates.present? && absentfirstexam.present? && passedfirstexam.present?

    if fields_present

      @failed_first_exam = candidates - absentfirstexam - passedfirstexam

    end

    expect(admission.failedfirstexam).to eq @failed_first_exam
  end

  it '-appealslodgedfirstexam' do
    @appeals_lodged_first_exam = 0

    appealsgrantedfirstexam = admission.appealsgrantedfirstexam
    appealsdeniedfirstexam = admission.appealsdeniedfirstexam

    fields_present = appealsgrantedfirstexam.present? && appealsdeniedfirstexam.present?

    if fields_present

      @appeals_lodged_first_exam = appealsgrantedfirstexam + appealsdeniedfirstexam

    end

    expect(admission.appealslodgedfirstexam).to eq @appeals_lodged_first_exam
  end

  it '-appealslodgedfinalexam' do
    @appeals_lodged_final_exam = 0

    appealsgrantedfinalexam = admission.appealsgrantedfinalexam
    appealsdeniedfinalexam = admission.appealsdeniedfinalexam

    fields_present = appealsgrantedfinalexam.present? && appealsdeniedfinalexam.present?

    if fields_present

      @appeals_lodged_final_exam = appealsgrantedfinalexam + appealsdeniedfinalexam

    end

    expect(admission.appealslodgedfinalexam).to eq @appeals_lodged_final_exam
  end

  it 'grants asked should be inconsistent when more than accredited' do
    admission.accreditedgrants = 9

    admission.grantsasked = 15

    expect(admission.grants_asked_consistent_with_accredited?).to be false
  end

  it '-grants_given_consistent_with_asked? is false with incorrect data' do
    admission.grantsasked = 18
    admission.grantsgiven = 20

    expect(admission.grants_given_consistent_with_asked?).to be false
  end

  it '-grants_given_consistent_with_asked? is true with correct data' do
    admission.grantsasked = 22
    admission.grantsgiven = 16

    expect(admission.grants_given_consistent_with_asked?).to be true
  end
end
