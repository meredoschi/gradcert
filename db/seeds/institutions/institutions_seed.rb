# frozen_string_literal: true

Institution.create!([
                      { name: 'Example Organization', institutiontype_id: 1,
                        address_id: 1, phone_id: 1, webinfo_id: 1, accreditation_id: 1,
                        abbreviation: 'Example Org' },
                      { name: 'State University', institutiontype_id: 2, address_id: 2,
                        phone_id: 2, webinfo_id: 2, accreditation_id: 2, legacycode: 1000,
                        abbreviation: 'State U' },
                      { name: 'City Community Hospital', institutiontype_id: 3, address_id: 3,
                        phone_id: 3, webinfo_id: 3, accreditation_id: 3, legacycode: 1001,
                        abbreviation: 'City Hospital' }
                    ])
