# frozen_string_literal: true

require 'date'
# if Time.zone.today.month>2
#    start_y=Time.zone.today.year+1
# else
#    start_y=Time.zone.today.year
# end
#
# start_y = '2018'
# start_m = '3'
# start_d = '1'
#
# term_start = [start_y, start_m, start_d].join('-')
#
# next_term = Schoolterm.where(start: term_start).where(pap: true).first
#
# next_term_id = next_term.id
#

start_m = Settings.schoolterm.start.month
start_d = Settings.schoolterm.start.day

start_y = if Time.zone.today.month >= start_m
            Time.zone.today.year + 1
          else
            Time.zone.today.year
          end

term_duration = Settings.schoolterm.duration # e.g. 2 years (for the longest program)
num_days_from_season_opening_to_term_start = Settings.schoolterm.registrations.open.days_before_term_starts
num_days_registrations_still_open_after_term_start = Settings.schoolterm.registrations.close.days_after_term_starts
num_days_from_admissions_debut_to_term_start = Settings.schoolterm.admissions.open.days_before_term_starts
num_days_from_admissions_closure_to_term_start = Settings.schoolterm.admissions.open.days_before_term_starts

num_schoolterms_to_seed = Settings.schoolterm.sample_quantity - 1
# index starts at 0

(0..num_schoolterms_to_seed).each do |i|
  start_y_m_d = [(start_y - i), start_m, start_d].join('-')
  start_dt = Date.parse(start_y_m_d) # in date format

  finish_dt = (start_dt + term_duration.year) - 1
  finish_y_m_d = finish_dt.to_s

  season_debut = start_dt - num_days_from_season_opening_to_term_start
  season_debut_time = season_debut.to_datetime

  season_closure = finish_dt + num_days_registrations_still_open_after_term_start
  season_closure_time = season_closure.to_datetime

  admissions_debut = start_dt - num_days_from_admissions_debut_to_term_start
  admissions_debut_time = admissions_debut.to_datetime

  admissions_closure = start_dt - num_days_from_admissions_closure_to_term_start
  admissions_closure_time = admissions_closure.to_datetime

  num_scholarships = Settings.schoolterm.scholarships_offered

  Schoolterm.create!(start: start_y_m_d, finish: finish_y_m_d, pap: true, medres: false, registrationseason: true, scholarshipsoffered: num_scholarships, seasondebut: season_debut_time, seasonclosure: season_closure_time, admissionsdebut: admissions_debut_time, admissionsclosure: admissions_closure_time)
end
