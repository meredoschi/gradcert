# frozen_string_literal: true

# Sample data for 2018
next_term = Schoolterm.where(start: '2018-3-1').where(pap: true).first

next_term_id = next_term.id

Placesavailable.create!([
                          { institution_id: 2, schoolterm_id: next_term_id, authorized: 12, allowregistrations: true },
                          { institution_id: 3, schoolterm_id: next_term_id, authorized: 8, allowregistrations: true }
                        ])
