require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user, :pap) }

  let(:contact) { FactoryBot.create(:contact, :pap_student_role) }

  # Associations

  it { is_expected.to belong_to(:institution) }
  it { is_expected.to belong_to(:permission) }
  it { is_expected.to have_one(:contact) }

  # Validations
  # http://stackoverflow.com/questions/808547/fully-custom-validation-error-message-with-rails

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  pending { is_expected.to validate_uniqueness_of(:email) }

  it { is_expected.to validate_length_of(:email).is_at_most(255) }

  it { is_expected.to validate_presence_of(:institution_id) }
  it { is_expected.to validate_presence_of(:permission_id) }

  # Class methods

  it '#called(fullname)' do
    fullname = contact.name
    users_called_fullname = User.joins(:contact).merge(Contact.called(fullname))
    expect(users_called_fullname).to eq User.called(fullname)
  end

  it '#pap' do
    users_pap = User.joins(:permission).merge(Permission.pap)
    expect(users_pap).to eq User.pap
  end

  it '#paplocalhr' do
    users_paplocalhr = User.joins(:permission).merge(Permission.paplocalhr)
    expect(users_paplocalhr).to eq User.paplocalhr
  end

  # Contacts with a name
  it '#named_contact' do
    users_named_contact = User.joins(:contact).merge(Contact.named)
    expect(users_named_contact).to eq User.named_contact
  end

  # Everyone, except system administrators
  it '#visible_to_readonly' do
    users_visible_to_readonly = User.joins(:permission).where("permissions.kind<>'admin'")
    expect(users_visible_to_readonly).to eq User.visible_to_readonly
  end

  it '#medres' do
    users_medres = User.joins(:permission).merge(Permission.medres)
    expect(users_medres).to eq User.medres
  end

  it '#from_own_institution(user)' do
    users_from_own_institution = User.where(users: { institution_id: user.institution.id })
    expect(users_from_own_institution).to eq User.from_own_institution(user)
  end

  it '#permissions' do
    users_permissions = User.joins(:permission)
    expect(users_permissions).to eq User.permissions
  end

  it '#with_student_role' do
    users_with_student_role = User.joins(contact: :role).where(roles: { student: true })
    expect(users_with_student_role).to eq User.with_student_role
  end

  it '#without_student_role' do
    users_without_student_role = User.where.not(id: User.with_student_role)
    expect(users_without_student_role).to eq User.without_student_role
  end

  it '#with_management_role' do
    users_with_management_role = User.joins(contact: :role).where(roles: { management: true })
    expect(users_with_management_role).to eq User.with_management_role
  end

  it '#without_management_role' do
    users_without_management_role = User.where.not(id: User.with_management_role)
    expect(users_without_management_role).to eq User.without_management_role
  end

  it '#neither_student_nor_management' do
    users_neither_student_nor_management = User.without_student_role.without_management_role
    expect(users_neither_student_nor_management).to eq User.neither_student_nor_management
  end

  it '#ordered_by_contact_name' do
    users_ordered_by_contact_name = User.includes(:contact).order('contacts.name')
    expect(users_ordered_by_contact_name).to eq User.ordered_by_contact_name
  end

  # Default is to sort by email address.
  it '#default_scope' do
    users_default_scope = User.ordered_by_email
    expect(users_default_scope).to eq User.default_scope
  end

  # Finder method
  it '#ordered_by_email' do
    users_ordered_by_email = User.order(email: :asc)
    expect(users_ordered_by_email).to eq User.ordered_by_email
  end

  it '#ids_with_contact' do
    users_ids_with_contact = User.joins(:contact).pluck(:user_id)
    expect(users_ids_with_contact).to eq User.ids_with_contact
  end

  it '#without_contact' do
    users_ids_without_contact = User.where.not(id: User.ids_with_contact)
    expect(users_ids_without_contact).to eq User.without_contact
  end

  # Instance methods

  it '-kind' do
    user_kind = user.kind
    expect(user_kind).to eq(user.kind)
  end

  it '-management_role?' do
    contact = FactoryBot.build(:contact, :pap_student_role)
    contact.user_id = user.id
    contact.save
    user_management_role_status = user.contact.role.management
    expect(user_management_role_status).to eq(user.management_role?)
  end

  it '-admin?' do
    user_permission_admin_status = user.permission.admin?
    expect(user_permission_admin_status).to eq(user.admin?)
  end

  it '-manager?' do
    user_permission_manager_status = user.permission.manager?
    expect(user_permission_manager_status).to eq(user.manager?)
  end

  it '-localadmin?' do
    user_permission_localadmin_status = user.permission.localadmin?
    expect(user_permission_localadmin_status).to eq(user.localadmin?)
  end

  it '-pap?' do
    user_permission_pap_status = user.permission.pap?
    expect(user_permission_pap_status).to eq(user.pap?)
  end

  it '-medres?' do
    user_permission_medres_status = user.permission.medres?
    expect(user_permission_medres_status).to eq(user.medres?)
  end

  it '-id_i18n' do
    user_id_i18n = I18n.t('activerecord.attributes.user.id') + ': ' + user.id.to_s
    expect(user_id_i18n).to eq user.id_i18n
  end

  it '-details' do
    contact = FactoryBot.build(:contact, :pap_student_role)
    contact.user_id = user.id
    contact.save
    user_details = user.email + ' (' + user.id_i18n + ') | ' + user.permission.description + ' | ' + user.institution.name
    expect(user_details).to eq user.details
  end

  it '-contact_name' do
    contact = FactoryBot.build(:contact, :pap_student_role)
    contact.user_id = user.id
    contact.save
    user_contact_name = user.contact.name
    expect(user_contact_name).to eq user.contact_name
  end

  # Convenience method
  it '-permission_type' do
    user_permission_kind = user.permission.kind
    expect(user_permission_kind).to eq user.permission.kind
  end
end
