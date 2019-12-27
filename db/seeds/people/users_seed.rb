# frozen_string_literal: true

possible_institution_ids = Institution.pluck(:id).sort

first_institution_id = possible_institution_ids.sample
possible_institution_ids.delete(first_institution_id)

second_institution_id = possible_institution_ids.sample
possible_institution_ids.delete(second_institution_id)

system_admin_permission = Permission.where(kind: 'admin').first
manager_permission = Permission.where(kind: 'papmgr').first
local_admin_permission = Permission.where(kind: 'paplocaladm').first

jane = User.create!(email: 'system-admin@example.com', password: 'samplepass', password_confirmation: 'samplepass', institution_id: first_institution_id, permission_id: system_admin_permission.id)
mark = User.create!(email: 'program-manager@example.com', password: 'samplepass', password_confirmation: 'samplepass', institution_id: first_institution_id, permission_id: manager_permission.id)
nat = User.create!(email: 'dean@example.org', password: 'samplepass', password_confirmation: 'samplepass', institution_id: second_institution_id, permission_id: local_admin_permission.id)

it_staff = Role.where(name: 'IT Staff').first
administrative_assistant = Role.where(name: 'Administrative assistant').first
local_manager = Role.where(name: 'Local manager').first

jane_contact = Contact.create!(user_id: jane.id, name: 'Jane Sample', role_id: it_staff.id)
mark_contact = Contact.create!(user_id: mark.id, name: 'Mark Doe', role_id: administrative_assistant.id)
nat_contact = Contact.create!(user_id: nat.id, name: 'Natalie Stevens', role_id: local_manager.id)

# Addresses

Address.create!(streetname_id: 34, addr: 'das Borboletas', complement: '', neighborhood: 'Centro', municipality_id: 2626, postalcode: '01000-000', contact_id: jane_contact.id, streetnum: 1)
Address.create!(streetname_id: 3, addr: 'Matriz', complement: '', neighborhood: 'Centro', municipality_id: 452, postalcode: '39665-000', contact_id: mark_contact.id, streetnum: 200)
Address.create!(streetname_id: 22, addr: 'do Soarez', complement: '', neighborhood: 'Chácara Nova', municipality_id: 5480, postalcode: '87450-000', contact_id: nat_contact.id, streetnum: 25)

# Personal infos

Personalinfo.create!(sex: 'F', gender: '', dob: '1990-01-07', idtype: 'RG', idnumber: '1111111111', state_id: 26, country_id: nil, socialsecuritynumber: '10000000008', tin: '10000000019', othername: '', contact_id: jane_contact.id, mothersname: 'Vanessa Sample')
Personalinfo.create!(sex: 'M', gender: '', dob: '1985-06-30', idtype: 'RG', idnumber: '2222222222', state_id: 26, country_id: nil, socialsecuritynumber: '10000000016', tin: '10000000108', othername: '', contact_id: mark_contact.id, mothersname: 'Kate Doe')
Personalinfo.create!(sex: 'M', gender: '', dob: '1964-02-11', idtype: 'RG', idnumber: '3333333333', state_id: 14, country_id: nil, socialsecuritynumber: '10000000105', tin: '10000000280', othername: '', contact_id: nat_contact.id, mothersname: 'Carla Stevens')

# Phones
Phone.create!(main: '11 5555-3275', mobile: '', other: '', contact_id: jane_contact.id)
Phone.create!(main: '11 5555-0450', mobile: '11 95555-0462', other: '', contact_id: mark_contact.id)
Phone.create!(main: '44 5555-8932', mobile: '', other: '44 5555-4378', contact_id: nat_contact.id)

# Web infos
Webinfo.create!(email: '', site: '', facebook: '', twitter: '#janesampleexampleonly', other: '', contact_id: jane_contact.id)
Webinfo.create!(email: '', site: 'www.markdoe.net', facebook: '', twitter: '', other: '', contact_id: mark_contact.id)
Webinfo.create!(email: '', site: '', facebook: '', twitter: '#natexamplesample', other: '', contact_id: nat_contact.id)
