require 'rails_helper'

RSpec.describe Registration, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  let(:schoolterm) { FactoryBot.create(:schoolterm, :pap) }

  it 'can be created' do
    print I18n.t('activerecord.models.registration').capitalize + ': '
    registration = FactoryBot.create(:registration)
    puts registration.name
  end

  it '#to_csv' do
    @registrations = create_list(:registration, 3)
  end
end
