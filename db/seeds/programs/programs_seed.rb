# Program(id:  institution_id:  pap: boolean, medres: boolean, address_id:  internal: boolean, accreditation_id:  admission_id:  schoolterm_id:  professionalspecialty_id:  previouscode: string, parentid:  gradcert: boolean)

next_term = Schoolterm.where(start: '2018-3-1').where(pap: true).first

next_term_id = next_term.id

Program.create!([
                  { schoolterm_id: next_term_id, programname_id: 1, duration: 1, institution_id: 2, pap: true, accreditation_id: 1, admission_id: 1, professionalspecialty_id: 1 },
                  { schoolterm_id: next_term_id, programname_id: 2, duration: 2, institution_id: 3, pap: true, accreditation_id: 2, admission_id: 2, professionalspecialty_id: 2 },
                  { schoolterm_id: next_term_id, programname_id: 3, duration: 1, institution_id: 3, gradcert: true, accreditation_id: 3, admission_id: 3, professionalspecialty_id: 3 },
                  { schoolterm_id: next_term_id, programname_id: 4, duration: 1, institution_id: 2, pap: true, accreditation_id: 4, admission_id: 4, professionalspecialty_id: 4 }
                ])
