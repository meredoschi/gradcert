# frozen_string_literal: true

# Program(id:  institution_id:  pap: boolean, medres: boolean, address_id:  internal: boolean, accreditation_id:  admission_id:  schoolterm_id:  professionalspecialty_id:  previouscode: string, parentid:  gradcert: boolean)

start_y = if Time.zone.today.month > 2
            Time.zone.today.year + 1
          else
            Time.zone.today.year
          end

# start_y = '2018'
start_m = '3'
start_d = '1'

term_start = [start_y, start_m, start_d].join('-')

next_term = Schoolterm.where(start: term_start).where(pap: true).first

next_term_id = next_term.id

# program.rb
# validate :duration_consistency

Program.new(schoolterm_id: next_term_id, programname_id: 1, duration: 1, institution_id: 2, pap: true, accreditation_id: 1, admission_id: 1, professionalspecialty_id: 1).save(validate: false)
Program.new(schoolterm_id: next_term_id, programname_id: 2, duration: 2, institution_id: 3, pap: true, accreditation_id: 2, admission_id: 2, professionalspecialty_id: 2).save(validate: false)
Program.new(schoolterm_id: next_term_id, programname_id: 3, duration: 1, institution_id: 3, gradcert: true, accreditation_id: 3, admission_id: 3, professionalspecialty_id: 3).save(validate: false)
Program.new(schoolterm_id: next_term_id, programname_id: 4, duration: 1, institution_id: 2, pap: true, accreditation_id: 4, admission_id: 4, professionalspecialty_id: 4).save(validate: false)
