require 'rails_helper'

RSpec.describe Registration, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  let(:schoolterm) { FactoryBot.create(:schoolterm, :pap) }

  it 'can be created' do
    print I18n.t('activerecord.models.registration').capitalize + ': '
    registration = FactoryBot.create(:registration)
    puts registration.name
    puts registration.student.bankaccount.bankbranch.code.to_s
  end

  it 'multiple can be created' do
    create_list(:registration, 4)
  end
end
