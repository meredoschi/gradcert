# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :admission do
    # Admission(id: integer, start: date, candidates: integer, absentfirstexam: integer,
    # absentfinalexam: integer, passedfirstexam: integer, appealsdeniedfirstexam: integer,
    # appealsgrantedfirstexam: integer, admitted: integer, convoked: integer, finish: date,
    # program_id: integer)

    #    program_id 1

    # program # verify why this was giving duplicate name problems
    association :program, factory: %i[program annual]

    trait :zero_amounts do
      # except start and finish, which are required
      association :program, factory: %i[program annual]
      start '2016-10-1'
      finish '2016-11-30'

      candidates 0
      absentfirstexam 0
      passedfirstexam 0
      absentfinalexam 0

      appealsgrantedfirstexam 0
      appealsdeniedfirstexam 0
      appealsgrantedfinalexam 0
      appealsdeniedfinalexam 0

      convoked 0
      admitted 0
      grantsasked 0
      grantsgiven 0
      accreditedgrants 0
    end

    # ///////////// Antecedents

    trait :grants_given_antecedents_consistent do
      accreditedgrants 10
      grantsasked 8
      grantsgiven 6
    end

    trait :grants_given_antecedents_inconsistent do
      accreditedgrants 10
      grantsasked 5
      grantsgiven 6
    end

    # leq -> "less than or equal to"
    trait :grants_given_leq_accredited do
      accreditedgrants 10
      grantsgiven 6
    end

    # gt -> "greather than"
    trait :given_more_than_accredited do
      accreditedgrants 10
      grantsgiven 14
    end

    # \\\\\\\\\\\\\

    trait :asked_more_than_accredited do
      grantsasked 10
      accreditedgrants 5
    end

    trait :given_more_than_asked do
      grantsasked 10
      grantsgiven 12
    end

    trait :candidates_more_than_grants_given do
      candidates 20
      grantsgiven 15
    end

    trait :absent_first_exam_more_than_candidates do
      candidates 35
      absentfirstexam 38
    end

    trait :passed_first_exam_inconsistent do
      candidates 35

      absentfirstexam 20
      passedfirstexam 20
    end

    trait :convoked_more_than_admitted do
      admitted 42
      convoked 50 # invite to register
    end

    trait :convoked_consistent_with_admitted do
      accreditedgrants 30
      grantsgiven 23
      candidates 20
      absentfirstexam 2
      passedfirstexam 15
      absentfinalexam 2
      insufficientfinalexamgrade 3
      admitted 10
      convoked 10 # less than or equal to
    end

    #  ------------------------------------------------
    # First exam consistent
    trait :first_exam do
      grantsgiven 23
      candidates 20
      absentfirstexam 2
      passedfirstexam 15
      # failedfirstexam = 3, virtual attribute
    end

    trait :appeals_inconsistent_with_first_exam_failures do
      appealsgrantedfirstexam 2
      appealsdeniedfirstexam  2
      # 4 > 3
    end

    trait :appeals_consistent_with_first_exam_failures do
      appealsgrantedfirstexam 1
      appealsdeniedfirstexam  2
      # 3 = 3
    end

    # ------------------------------------

    # Final exam consistent
    trait :final_exam do
      grantsgiven 23
      candidates 20
      absentfirstexam 2
      passedfirstexam 15
      absentfinalexam 2
      insufficientfinalexamgrade 3
      admitted 10
    end

    # Final exam consistent
    trait :final_exam_inconsistent do
      grantsgiven 23
      candidates 20
      absentfirstexam 2
      passedfirstexam 15
      absentfinalexam 2
      insufficientfinalexamgrade 1 # should be 3
      admitted 10
    end

    trait :appeals_inconsistent_with_final_exam_failures do
      appealsgrantedfinalexam 2
      appealsdeniedfinalexam  2
      # 4 > 3
    end

    trait :appeals_consistent_with_final_exam_failures do
      appealsgrantedfinalexam 1
      appealsdeniedfinalexam  2
      # 3 = 3
    end

    # ---------------------------------------------

    trait :more_grants_given_than_asked do
      grantsasked 18
      grantsgiven 20
    end
  end
end
