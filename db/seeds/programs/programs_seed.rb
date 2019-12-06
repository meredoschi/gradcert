# frozen_string_literal: true

# Program(id:  institution_id:  pap: boolean, medres: boolean, address_id:  internal: boolean, accreditation_id:  admission_id:  schoolterm_id:  professionalspecialty_id:  previouscode: string, parentid:  gradcert: boolean)

def initial_accreditation(program, from_dt)
  accreditation = Accreditation.new(program_id: program.id, start: from_dt, original: true, suspended: false, revoked: false, renewed: false)

  #  accreditation.save

  accreditation.save(validate: false)

  accreditation
end


most_recent_schoolterm_start_dt = Schoolterm.pluck(:start).max

most_recent_schoolterm = Schoolterm.where(start: most_recent_schoolterm_start_dt).first

# program.rb
# validate :duration_consistency

institution_ids = Institution.pluck(:id) # array

next_institution_id = institution_ids.sample
institution_ids.delete(next_institution_id)
first_institution = Institution.find next_institution_id

next_institution_id = institution_ids.sample
institution_ids.delete(next_institution_id)
second_institution = Institution.find next_institution_id

next_institution_id = institution_ids.sample
institution_ids.delete(next_institution_id)
third_institution = Institution.find next_institution_id

# Program.new(schoolterm_id: next_term_id, programname_id: next_program_name_id, duration: 1, institution_id: 2, pap: true, accreditation_id: 1, admission_id: 1, professionalspecialty_id: 1).save(validate: false)

# Program.new(schoolterm_id: next_term_id, programname_id: 1, duration: 1, institution_id: 2, pap: true, accreditation_id: 1, admission_id: 1, professionalspecialty_id: 1).save(validate: false)

tropical_biology = Programname.where(name: 'Tropical biology').first

clinical_psychology = Programname.where(name: 'Clinical Psychology').first
nursing_elderly = Programname.where(name: 'Nursing for the elderly').first
horse_management = Programname.where(name: 'Horse management techniques').first

biology_specialty = Professionalspecialty.where(name: 'Biology').first

nursing_specialty = Professionalspecialty.where(name: 'Nursing').first
business_specialty = Professionalspecialty.where(name: 'Business Administration').first

tropical_biology_program = Program.new(schoolterm_id: most_recent_schoolterm.id,
                                       programname_id: tropical_biology.id, institution_id: first_institution.id,
                                       professionalspecialty_id: biology_specialty.id, duration: 2)

#Accreditation.delete_all
#Admission.delete_all
#Schoolyear.delete_all
#Program.delete_all

Schoolyear.create(program_id: tropical_biology_program.id, programyear: 1)
Schoolyear.create(program_id: tropical_biology_program.id, programyear: 2)

tropical_biology_program.save(validate: false)

program_accreditation = initial_accreditation(tropical_biology_program, '2016-1-1')
program_accreditation.program_id = tropical_biology_program.id
program_accreditation.save
tropical_biology_program.accreditation_id = program_accreditation.id
tropical_biology_program.save

admissions_start_dt = most_recent_schoolterm_start_dt - 120.days
admissions_finish_dt = admissions_start_dt + 45.days

# print 'Program ID: '
# puts tropical_biology_program.id.to_s
program_admission = Admission.create!(program_id: tropical_biology_program.id,
                                      start: admissions_start_dt,
                                      finish: admissions_finish_dt)

# print 'Accreditations: '
# puts Accreditation.count.to_s

# print 'Admissions: '
# puts Admission.count.to_s

# print 'Programs: '
# puts Program.count.to_s

# print 'Schoolyears: '
# puts Schoolyear.count.to_s

# Accreditation.create!([
#                        { program_id: 1, original: true, suspended: false, revoked: false, renewed: false, start: '2016-1-1' },
#                        { program_id: 2, original: true, suspended: false, revoked: false, renewed: false, start: '2017-1-1' },
#                        { program_id: 3, original: true, suspended: false, revoked: false, renewed: false, start: '2018-1-1' },
#                        { program_id: 4, original: true, suspended: false, revoked: false, renewed: false, start: '2018-1-1' }
#                      ])

# Admission.create!([
#                    { program_id: 1, start: '2015-11-1', finish: '2015-12-31' },
#                    { program_id: 2, start: '2016-11-1', finish: '2016-12-31' },
#                    { program_id: 3, start: '2017-11-1', finish: '2017-12-31' },
#                    { program_id: 4, start: '2017-11-1', finish: '2017-12-31' }
#                  ])

# Schoolyear.create!([
#                     { program_id: 1, programyear: 1 },
#                     { program_id: 2, programyear: 1 },
#                     { program_id: 2, programyear: 2 },
#                     { program_id: 3, programyear: 1 },
#                     { program_id: 4, programyear: 1 }

#                   ])

# Program.new(schoolterm_id: next_term_id, programname_id: 1, duration: 1, institution_id: 2, pap: true, accreditation_id: 1, admission_id: 1, professionalspecialty_id: 1).save(validate: false)
# Program.new(schoolterm_id: next_term_id, programname_id: 2, duration: 2, institution_id: 3, pap: true, accreditation_id: 2, admission_id: 2, professionalspecialty_id: 2).save(validate: false)
# Program.new(schoolterm_id: next_term_id, programname_id: 3, duration: 1, institution_id: 3, gradcert: true, accreditation_id: 3, admission_id: 3, professionalspecialty_id: 3).save(validate: false)
# Program.new(schoolterm_id: next_term_id, programname_id: 4, duration: 1, institution_id: 2, pap: true, accreditation_id: 4, admission_id: 4, professionalspecialty_id: 4).save(validate: false)
