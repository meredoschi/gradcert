# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  #  Schoolterm(id: integer, start: date, finish: date, pap: boolean,
  #  medres: boolean, created_at: datetime, updated_at: datetime,
  #  registrationseason: boolean, scholarshipsoffered: integer, seasondebut: datetime,
  #  seasonclosure: datetime, admissionsdebut: datetime, admissionsclosure: datetime)
  factory :schoolterm do
    start_m = Settings.schoolterm.start.month
    start_d = Settings.schoolterm.start.day

    start_y = if Time.zone.today.month >= start_m
                Time.zone.today.year + 1
              else
                Time.zone.today.year
              end

    term_duration = Settings.schoolterm.duration # e.g. 2 years (for the longest program)
    num_days_from_season_opening_to_term_start = Settings.schoolterm.registrations
                                                         .open.days_before_term_starts
    num_days_registrations_still_open_after_term_start = Settings.schoolterm.registrations
                                                                 .close.days_after_term_starts
    num_days_admissions_debut_prior_to_term_start = Settings.schoolterm.admissions
                                                            .open.days_before_term_starts
    num_days_between_admissions_closure_and_term_start = Settings.schoolterm.admissions
                                                                 .close.days_before_term_starts

    start_y_m_d = [start_y, start_m, start_d].join('-')
    start_dt = Date.parse(start_y_m_d) # in date format

    finish_dt = (start_dt + term_duration.year) - 1
    finish_y_m_d = finish_dt.to_s

    season_debut = start_dt - num_days_from_season_opening_to_term_start
    season_debut_time = season_debut.to_datetime

    season_closure = season_debut + num_days_from_season_opening_to_term_start +  \
                     num_days_registrations_still_open_after_term_start
    season_closure_time = season_closure.to_datetime

    admissions_debut = start_dt - num_days_admissions_debut_prior_to_term_start
    admissions_debut_time = admissions_debut.to_datetime

    admissions_closure = start_dt - num_days_between_admissions_closure_and_term_start
    admissions_closure_time = admissions_closure.to_datetime

    num_scholarships = Settings.schoolterm.scholarships_offered

    start { start_y_m_d }
    finish { finish_y_m_d }
    seasondebut { season_debut_time }
    seasonclosure { season_closure_time }
    admissionsdebut { admissions_debut_time }
    admissionsclosure { admissions_closure_time }
    scholarshipsoffered { num_scholarships }

    trait :pap do
      pap true
      medres false
    end

    trait :medres do
      medres true
      pap false
    end

    # Test use only
    trait :undefined do
      medres false
      pap false
    end

    trait :past do
      before(:create) do |schoolterm|
        offset = 1.year

        schoolterm.start -= offset
        schoolterm.finish -= offset
        schoolterm.seasondebut -= offset
        schoolterm.seasonclosure -= offset
        schoolterm.admissionsdebut -= offset
        schoolterm.admissionsclosure -= offset
      end
    end
  end
end
