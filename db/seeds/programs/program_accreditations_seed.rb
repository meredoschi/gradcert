# frozen_string_literal: true

# Accreditation( institution_id:  start: date, renewal: date, revoked: boolean, revocation: date, comment: string, created_at: datetime, updated_at: datetime, suspension: date, suspended: boolean, original: boolean, renewed: boolean, program_id:  registration_id:  confirmed: boolean)
Accreditation.create!([
                        { program_id: 1, original: true, suspended: false, revoked: false, renewed: false, start: '2016-1-1' },
                        { program_id: 2, original: true, suspended: false, revoked: false, renewed: false, start: '2017-1-1' },
                        { program_id: 3, original: true, suspended: false, revoked: false, renewed: false, start: '2018-1-1' },
                        { program_id: 4, original: true, suspended: false, revoked: false, renewed: false, start: '2018-1-1' }
                      ])
