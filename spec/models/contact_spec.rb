# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { FactoryBot.create(:user, :pap) }

  let(:contact) { FactoryBot.create(:contact, :pap_student_role) }

  let(:fullname) { 'James sample' }

  let(:institution) { FactoryBot.create(:institution) }

  #  pending "add some examples to (or delete) #{__FILE__}"

  # https://stackoverflow.com/questions/30927459/rspec-validation-failed-name-has-already-been-taken
  #  let(:user) { FactoryBot.create(:user) }

  #  let(:contact) { FactoryBot.create(:contact, user: user) }

  it 'can be created (PAP)' do
    FactoryBot.create(:contact, :pap_student_role)
  end

  context 'associations' do
    # .dependent(:restrict_with_exception).inverse_of(:user)
    it { is_expected.to belong_to(:role) }
    it {
      is_expected.to have_many(:student).dependent(:restrict_with_exception)
                                        .inverse_of(:contact)
    }
    it { is_expected.to belong_to(:user) }

    it {
      is_expected.to have_many(:assessment).dependent(:restrict_with_exception)
                                           .inverse_of(:contact)
    }

    it {
      is_expected.to have_many(:supervisor).dependent(:restrict_with_exception)
                                           .inverse_of(:contact)
    }

    it {
      is_expected.to have_one(:address).dependent(:restrict_with_exception)
                                       .inverse_of(:contact)
    }
    it { is_expected.to accept_nested_attributes_for(:address) }

    it {
      is_expected.to have_one(:phone).dependent(:restrict_with_exception)
                                     .inverse_of(:contact)
    }
    it { is_expected.to accept_nested_attributes_for(:phone) }

    it {
      is_expected.to have_one(:webinfo).dependent(:restrict_with_exception)
                                       .inverse_of(:contact)
    }
    it { is_expected.to accept_nested_attributes_for(:webinfo) }

    it {
      is_expected.to have_one(:personalinfo).dependent(:restrict_with_exception)
                                            .inverse_of(:contact)
    }
    it { is_expected.to accept_nested_attributes_for(:personalinfo) }
  end

  context 'validations' do
    it '-user_with_staff_permission_must_not_take_on_student_role' do
      role_id_i18n = I18n.t('activerecord.attributes.contact.role_id')

      msg = I18n.t('validation_failed') + ': ' + role_id_i18n + ' ' + \
            I18n
            .t('activerecord.errors.models.
              contact.attributes.role_id.staff_may_not_take_student_role')

      expect do
        FactoryBot.create(:contact, :staff_permission_with_student_role)

        #        FactoryBot.create(:contact, :student_permission_with_staff_role)
        # https://stackoverflow.com/questions/45128434/comparing-rspec-custom-activerecordrecordinvalid-errors-messages
      end .to raise_error(ActiveRecord::RecordInvalid, msg)
    end

    it '-user_with_student_permission_must_not_take_on_staff_role' do
      role_id_i18n = I18n.t('activerecord.attributes.contact.role_id')

      msg = I18n.t('validation_failed') + ': ' + role_id_i18n + ' ' + \
            I18n
            .t('activerecord.errors.models.contact.attributes.
              role_id.student_may_not_take_staff_role')

      expect do
        FactoryBot.create(:contact, :student_permission_with_staff_role)
        # https://stackoverflow.com/questions/45128434/comparing-rspec-custom-activerecordrecordinvalid-errors-messages
      end .to raise_error(ActiveRecord::RecordInvalid, msg)
    end

    it '-name_whitespacing_is_consistent' do
      name_i18n = I18n.t('activerecord.attributes.contact.name')

      msg = I18n.t('validation_failed') + ': ' + name_i18n + ' ' + \
            I18n
            .t('activerecord.errors.models.contact.attributes.name
              .must_have_consistent_whitespacing')

      expect do
        FactoryBot.create(:contact, :name_with_blanks)
        # https://stackoverflow.com/questions/45128434/comparing-rspec-custom-activerecordrecordinvalid-errors-messages
      end .to raise_error(ActiveRecord::RecordInvalid, msg)
    end
  end

  context 'class methods' do
    # Registered students
    it '#registered' do
      registered_student_contacts = Contact.joins(student: :registration)
      expect(registered_student_contacts).to eq(Contact.registered)
    end

    # Are not registered students
    it '#not_registered' do
      contacts_who_are_not_registered_students = Contact.where.not(id: Contact.registered)
      expect(contacts_who_are_not_registered_students).to eq(Contact.not_registered)
    end

    # Not supervisors (i.e. without a supervisor record associated with it, regardless of role)
    it '#not_supervisor' do
      contacts_who_are_not_supervisors = Contact.where.not(id: Contact.supervisor)
      expect(contacts_who_are_not_supervisors).to eq(Contact.not_supervisor)
    end

    it '#latest_contacts_with_student_roles' do
      latest_schoolterm = Schoolterm.latest

      if latest_schoolterm.present? && latest_schoolterm.start.present?

        latest_term_beginning_of_calendar_year = latest_schoolterm.start.beginning_of_year
        recent_contacts_with_student_roles = Contact.with_student_role
                                                    .where('contacts.created_at > ? ',
                                                           latest_term_beginning_of_calendar_year)

      end

      expect(recent_contacts_with_student_roles).to eq(Contact.latest_contacts_with_student_roles)
    end

    it '#latest_student_contact_ids' do
      most_recent_students = Contact.latest_contacts_with_student_roles

      if most_recent_students.present?

        contact_ids_for_latest_students = most_recent_students.joins(:student).pluck(:contact_id)

      end

      expect(contact_ids_for_latest_students).to eq(Contact.latest_student_contact_ids)
    end

    it '#ready_to_become_students' do
      latest_contacts_with_a_student_role = Contact.latest_contacts_with_student_roles

      if latest_contacts_with_a_student_role.present?
        contacts_ready_to_become_students = Contact.latest_contacts_with_a_student_role.wher
                                                   .not(id: Contact.latest_student_contact_ids)
      end

      expect(contacts_ready_to_become_students).to eq(Contact.ready_to_become_students)
    end

    it '#num_ready_to_become_students' do
      num_contacts_ready_to_become_students = 0

      if Contact.ready_to_become_students.present?
        num_contacts_ready_to_become_students = Contact.ready_to_become_students.count
      end

      expect(num_contacts_ready_to_become_students).to eq(Contact.num_ready_to_become_students)
    end

    # Added for convenience (audit rake tasks) - August 2017
    it '#called(fullname)' do
      contacts_who_are_called_fullname = Contact.where(name: fullname) # generally unique
      expect(contacts_who_are_called_fullname).to eq(Contact.called(fullname))
    end

    # Brazilian Social Security Number - Verification digit
    it '#nit_dv' do
      contact_nit_div = contact.personalinfo.nit_dv
      expect(contact_nit_div).to eq(contact.nit_dv)
    end

    # New for 2017 - Ability
    it '#veterans_today' do
      todays_veteran_students_contact_ids = Student.veterans_today.pluck(:contact_id)
      todays_veteran_students = Contact.where(id: todays_veteran_students_contact_ids)
      expect(todays_veteran_students).to eq(Contact.veterans_today)
    end

    # current repeating students
    it '#todays_repeats' do
      todays_repeat_students_contact_ids = Student.veterans_today.pluck(:contact_id)
      todays_repeat_students = Contact.where(id: todays_repeat_students_contact_ids)
      expect(todays_repeat_students).to eq(Contact.todays_repeats)
    end

    # Alias, for convenience
    # Used in ability.rb
    it '#repeat_registration' do
      contacts_with_repeat_registrations = Contact.todays_repeats
      expect(contacts_with_repeat_registrations).to eq(Contact.repeat_registration)
    end

    # N.B. Make up means: substitute missed school or training day(s)
    it '#makeup' do
      makeup_ids = Student.makeup.pluck(:contact_id)
      contacts_makeup = Contact.where(id: makeup_ids)
      expect(contacts_makeup).to eq(Contact.makeup)
    end

    # Alias, for convenience
    # Used in ability.rb
    it '#makeup_registration' do
      expect(Contact.makeup_registration).to eq(Contact.makeup)
    end

    # Has a student record associated to it (need not be registered in a program yet)
    # To better distinguish from registered students
    it '#with_student_information' do
      contacts_with_student_information = Contact.joins(:student)
      expect(contacts_with_student_information).to eq(Contact.with_student_information)
    end

    it '#without_student_information' do
      # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
      contacts_without_student_information = Contact.where.not(id: Contact.with_student_information)
      expect(contacts_without_student_information).to eq(Contact.without_student_information)
    end

    # Has supervisor information
    it '#registered_supervisor' do
      registered_supervisors = Contact.joins(:supervisor)
      expect(registered_supervisors).to eq(Contact.registered_supervisor)
    end

    it '#from_own_institution_but_not_registered_yet(user)' do
      # Actually it is the student record that would be registered
      contacts_from_own_institution_not_registered_yet = Contact.from_own_institution(user)
                                                                .not_registered
      expect(contacts_from_own_institution_not_registered_yet)
        .to eq(Contact.from_own_institution_but_not_registered_yet(user))
    end

    it '#named' do
      named_contacts = Contact.where.not(id: Contact.nameless)
      expect(named_contacts).to eq(Contact.named)
    end

    it '#supervisor' do
      contacts_who_are_supervisors = Contact.joins(:supervisor)
      expect(contacts_who_are_supervisors).to eq(Contact.supervisor)
    end

    it '#not_supervisor' do
      # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
      contacts_who_are_not_supervisors = Contact.where.not(id: Contact.supervisor)
      expect(contacts_who_are_not_supervisors).to eq(Contact.not_supervisor)
    end

    # Without student or supervisor records associated with it ("childless")
    it '#plain' do
      plain_contacts_records = Contact.without_student_information.not_supervisor
      expect(plain_contacts_records).to eq(Contact.plain)
    end

    # --- training sessions
    # Order contacts by institution name
    it '#ordered_by_institution_name' do
      contacts_ordered_by_institution_name = Contact.joins(user: :institution)
                                                    .order('institutions.name')
      expect(contacts_ordered_by_institution_name).to eq(Contact.ordered_by_institution_name)
    end
    # Ordered by most accessed
    it '#ordered_by_most_frequent_users' do
      contacts_ordered_by_most_frequent_users = Contact.joins(:user)
                                                       .order('users.sign_in_count desc')
      expect(contacts_ordered_by_most_frequent_users).to eq(Contact.ordered_by_most_frequent_users)
    end

    it '#with_student_role' do
      contacts_with_student_role = Contact.joins(:role).merge(Role.student)
      expect(contacts_with_student_role).to eq(Contact.with_student_role)
    end

    it '#with_teaching_role' do
      contacts_with_teaching_role = Contact.joins(:role).merge(Role.teaching)
      expect(contacts_with_teaching_role).to eq(Contact.with_teaching_role)
    end

    it '#with_collaborator_role' do
      contacts_with_collaborator_role = Contact.joins(:role).where(roles: { collaborator: true })
      expect(contacts_with_collaborator_role).to eq(Contact.with_collaborator_role)
    end

    # Belonging to the own user - returns an active record relation (1 record expected, has one)
    it '#own(user)' do
      contact_related_to_own_user = Contact.joins(:user).where(user_id: user.id)
      expect(contact_related_to_own_user).to eq(Contact.own(user))
    end

    # Alias
    it '#teacher' do
      expect(Contact.teacher).to eq(Contact.with_teaching_role)
    end

    it '#with_evaluator_role' do
      expect(Contact.with_collaborator_role).to eq(Contact.with_evaluator_role)
    end

    it '#from_institution(institution)' do
      contacts_from_institution = Contact.joins(:user)
                                         .where(users: { institution_id: institution.id })
      expect(contacts_from_institution).to eq(Contact.from_institution(institution))
    end

    it '#pap' do
      contact_pap = Contact.joins(:user).merge(User.pap)
      expect(contact_pap).to eq(Contact.pap)
    end

    it '#medres' do
      contact_medres = Contact.joins(:user).merge(User.medres)
      expect(contact_medres).to eq(Contact.medres)
    end

    it '#paplocalhr' do
      contact_pap_local_hr = Contact.joins(:user).merge(User.paplocalhr)
      expect(contact_pap_local_hr).to eq(Contact.paplocalhr)
    end

    it '#with_management_role' do
      contact_with_management_role = Contact.joins(:role).merge(Role.management)
      expect(contact_with_management_role).to eq(Contact.with_management_role)
    end

    # Those contact ids with assessments related to them
    it '#ids_with_assessments' do
      contact_ids_with_assessments = Assessment.joins(:contact).select(:contact_id).distinct
      expect(contact_ids_with_assessments).to eq(Contact.ids_with_assessments)
    end

    # Contacts with student roles but no student records created for them (yet)
    it '#may_become_students' do
      contacts_which_may_become_students = Contact.with_student_role.without_student_information
      expect(contacts_which_may_become_students).to eq(Contact.may_become_students)
    end

    it '#possible_students_exist?' do
      are_there_contacts_which_may_become_students = Contact.may_become_students.count.positive?
      expect(are_there_contacts_which_may_become_students).to eq(Contact.possible_students_exist?)
    end
  end

  context 'instance methods' do
    # Gender or sex diversity
    it '-diversity?' do
      is_contact_diversity = contact.personalinfo.genderdiversity?
      expect(is_contact_diversity).to eq(contact.diversity?)
    end

    it '-id_i18n' do
      contact_id_i18n = I18n.t('activerecord.attributes.contact.id') + ': ' + contact.id.to_s
      expect(contact_id_i18n).to eq(contact.id_i18n)
    end

    it '-details' do
      contact_details = contact.name + ' (' + contact.id_i18n + ') | ' \
      + contact.role_name + ' | ' + contact.institution_name
      expect(contact_details).to eq(contact.details)
    end

    it '-nameless?' do
      nameless_contact = (contact.name == '')
      expect(nameless_contact).to eq(contact.nameless?)
    end

    it '-institution_name' do
      contact_institution_name = contact.user.institution_name
      expect(contact_institution_name).to eq(contact.institution_name)
    end

    it '-role_name' do
      contact_role_name = contact.role.name
      expect(contact_role_name).to eq(contact.role_name)
    end

    it '-name_and_institution' do
      contact_name_and_institution = contact.name + ' (' + contact.institution_name + ')'
      expect(contact_name_and_institution).to eq(contact.name_and_institution)
    end

    it '-fulladdress' do
      contact_full_address = contact.address.street
      expect(contact_full_address).to eq(contact.fulladdress)
    end

    it '-student_role?' do
      is_contact_with_student_role = contact.role.student?
      expect(is_contact_with_student_role).to eq(contact.student_role?)
    end

    # Is there a student record for this contact?
    it '-student?' do
      is_contact_with_student = contact.student.present?
      expect(is_contact_with_student).to eq(contact.student?)
    end

    context 'protected' do
      # https://stackoverflow.com/questions/267237/whats-the-best-way-to-unit-test-protected-private-methods-in-ruby
      before(:each) do
        Contact.send(:public, *Contact.protected_instance_methods)
      end

      it '-with_name_email_postalcode?' do
        is_contact_with_name_email_postalcode = (contact.name.present? && contact.email.present? \
          && contact.address.postalcode.present?)
        expect(is_contact_with_name_email_postalcode).to eq(contact.with_name_email_postalcode?)
      end

      it '-squish_whitespaces' do
        if contact.with_name_email_postalcode?
          squished_name_email_postalcode = [contact.name, contact.email,
                                            contact.address.postalcode].each(&:squish)
        end

        expect(squished_name_email_postalcode).to eq(contact.squish_whitespaces)
      end
    end

    #    context 'private' do

    #      before(:each) do
    #        Contact.send(:public, *Contact.private_instance_methods)
    #      end

    #    end

    it '-tin' do
      taxpayer_id_number = contact.personalinfo.tin
      expect(taxpayer_id_number).to eq(contact.tin)
    end

    # Alias, for convenience (in Brazil)
    it '-cpf' do
      expect(contact.cpf).to eq(contact.tin)
    end

    it '-birth' do
      contact_birth = contact.personalinfo.birth
      expect(contact_birth).to eq(contact.birth)
    end

    it '-name_birth' do
      contact_name_birth = contact.name + ' [' + contact.birth + ']'
      expect(contact_name_birth).to eq(contact.name_birth)
    end

    it '-name_birth_tin' do
      contact_name_birth_tin = contact.name_birth + ' (' + contact.tin + ')'
      expect(contact_name_birth_tin).to eq(contact.name_birth_tin)
    end
  end

  # Returns name with characters (and blanks) only
  # Required for brazilian bank file generation
  it 'bankingname' do
    contact_banking_name = I18n.transliterate(contact.name).gsub(/[^a-zA-Z\s]/, ' ')

    expect(contact_banking_name).to eq(contact.bankingname)
  end

  it '-alphabetical_name' do
    contact_alphabetical_name = contact.name.gsub(/[^a-zA-Z\s]/, ' ')

    expect(contact_alphabetical_name).to eq(contact.alphabetical_name)
  end

  it 'birth (from personalinfo)' do
    contact_birth = contact.personalinfo.birth

    expect(contact_birth).to eq(contact.birth)
  end

  it 'tin' do
    contact_tin = contact.personalinfo.tin

    expect(contact_tin).to eq(contact.tin)
  end

  it '-cpf (alias to taxpayer identification number - tin)' do
    contact_cpf = contact.tin
    expect(contact_cpf).to eq(contact.cpf)
  end

  it 'name_birth' do
    contact_name_birth = contact.name + ' [' + contact.birth + ']'

    expect(contact_name_birth).to eq(contact.name_birth)
  end

  it 'name_birth_tin' do
    contact_name_birth_tin = contact.name_birth + ' (' + contact.tin + ')'

    expect(contact_name_birth_tin).to eq(contact.name_birth_tin)
  end
end

#
#   def self.latest_contacts_with_student_roles
#   with_student_role.where('contacts.created_at > ? ', Schoolterm.latest.start.beginning_of_year)
# end
# def self.latest_student_contact_ids
# latest_contacts_with_student_roles.joins(:student).pluck(:contact_id)
# end
# Latest
# def self.ready_to_become_students
# latest_contacts_with_student_roles.where.not(id: latest_student_contact_ids)
# end
# Added for convenience (audit rake tasks) - August 2017
# def self.called(fullname)
# where(name: fullname)
# end
# def user_with_staff_permission_must_not_take_on_student_role
# return unless user.permission.staff? && role.student?
# errors.add(:role_id, :staff_may_not_take_student_role)
# end
# def  user_with_regular_permission_must_not_take_on_staff_role
# return unless user.permission.regular? && role.staff?
# errors.add(:role_id, :student_may_not_take_staff_role)
# end
