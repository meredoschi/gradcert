require 'rails_helper'

RSpec.describe Student, type: :model do
  # let(:student) { FactoryBot.create(:student) }

  #  pending "add some examples to (or delete) #{__FILE__}"

  # https://stackoverflow.com/questions/30927459/rspec-validation-failed-name-has-already-been-taken
  #  let(:user) { FactoryBot.create(:user) }

  #  let(:student) { FactoryBot.create(:student, user: user) }

  it 'can be created (PAP)' do
    FactoryBot.create(:student)
  end
end
