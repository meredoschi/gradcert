# Admission(id:  start: date, finish: date, created_at: datetime, updated_at: datetime, program_id:  grantsasked:  grantsgiven:  accreditedgrants:  appealsgrantedfinalexam:  appealsdeniedfinalexam:  candidates:  absentfirstexam:  absentfinalexam:  passedfirstexam:  appealsdeniedfirstexam:  appealsgrantedfirstexam:  admitted:  convoked:  insufficientfinalexamgrade: integer)

Admission.create!([
                    { program_id: 1, start: '2015-11-1', finish: '2015-12-31' },
                    { program_id: 2, start: '2016-11-1', finish: '2016-12-31' },
                    { program_id: 3, start: '2017-11-1', finish: '2017-12-31' },
                    { program_id: 4, start: '2017-11-1', finish: '2017-12-31' }
                  ])
