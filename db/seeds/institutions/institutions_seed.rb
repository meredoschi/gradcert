# frozen_string_literal: true

def accredited_institution(inst_name, inst_abbrv, dt_accredited)
  institutiontype_ids = Institutiontype.pluck(:id)

  institution = Institution.create(name: inst_name, abbreviation: inst_abbrv,
                                   institutiontype_id: institutiontype_ids.sample)

  Accreditation.create(institution_id: institution.id, original: true, start: dt_accredited,
                       revoked: false, suspended: false, renewed: false)

  institution
end

streetname_ids = Streetname.pluck(:id)

# First sample institution
institution = accredited_institution('Example Organization', 'Example Org', '2015-01-01')
# web_information(institution: institution,  inst_email: 'info@example.org', inst_site: '', inst_twitter: '#example' )
webinfo = Webinfo.create(email: 'info@example.org', twitter: '#example', institution_id: institution.id)
institution.webinfo_id = webinfo.id
phone = Phone.create(main: '17 5555-0149', mobile: '', other: '', fax: '17 5555-0150', institution_id: institution.id)
institution.phone_id = phone.id
address = Address.create(streetname_id: streetname_ids.sample, addr: 'Jake Sample', complement: '', neighborhood: 'Jardim Tranquilo', municipality_id: 4516, postalcode: '15620-000', institution_id: institution.id, streetnum: 15)
institution.address_id = address.id
institution.save

# Second sample institution
institution = accredited_institution('State University', 'State U', '2016-07-02')

webinfo = Webinfo.create(site: 'www.state-u.org', twitter: '#example', institution_id: institution.id)
institution.webinfo_id = webinfo.id

phone = Phone.create(main: '44 5555-0156', other: '44 5555-0300', institution_id: institution.id)
institution.phone_id = phone.id

address = Address.create(streetname_id: 3, addr: 'Matriz', complement: '', neighborhood: 'Centro', municipality_id: 5480, postalcode: '87450-000', institution_id: institution.id, streetnum: 200)
institution.address_id = address.id

institution.save

# Third sample institution

institution = accredited_institution('City Community Hospital', 'City Hospital', '2018-01-01')

webinfo = Webinfo.create(email: 'info@cityhospital.org', site: 'www.cityhospital.org', institution_id: institution.id)
institution.webinfo_id = webinfo.id

phone = Phone.create(main: '11 5555-3629', other: '11 5555-1161', institution_id: institution.id)
institution.phone_id = phone.id

address = Address.create(streetname_id: 12, addr: 'do Comércio', complement: 'Zona Industrial', neighborhood: 'Centro', municipality_id: 5480, postalcode: '89642-000', institution_id: institution.id, streetnum: 40)
institution.address_id = address.id

institution.save
