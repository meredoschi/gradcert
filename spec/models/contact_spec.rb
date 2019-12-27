# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { FactoryBot.create(:contact, :pap_student_role) }

  #  pending "add some examples to (or delete) #{__FILE__}"

  # https://stackoverflow.com/questions/30927459/rspec-validation-failed-name-has-already-been-taken
  #  let(:user) { FactoryBot.create(:user) }

  #  let(:contact) { FactoryBot.create(:contact, user: user) }

  it 'can be created (PAP)' do
    FactoryBot.create(:contact, :pap_student_role)
  end

  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_many(:supervisor) }
  it { is_expected.to have_many(:student) }

  it { is_expected.to have_one(:address) }
  it { is_expected.to accept_nested_attributes_for(:address) }

  it { is_expected.to have_one(:phone) }
  it { is_expected.to accept_nested_attributes_for(:phone) }

  it { is_expected.to have_one(:webinfo) }
  it { is_expected.to accept_nested_attributes_for(:webinfo) }

  it { is_expected.to have_one(:personalinfo) }
  it { is_expected.to accept_nested_attributes_for(:personalinfo) }

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
