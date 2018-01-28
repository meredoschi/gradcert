require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { FactoryBot.create(:clerical_pap) }

  #  pending "add some examples to (or delete) #{__FILE__}"

  # https://stackoverflow.com/questions/30927459/rspec-validation-failed-name-has-already-been-taken
  #  let(:user) { FactoryBot.create(:user) }

  #  let(:contact) { FactoryBot.create(:contact, user: user) }

  it 'can be created (PAP)' do
    FactoryBot.create(:contact, :clerical_pap)
  end
end
