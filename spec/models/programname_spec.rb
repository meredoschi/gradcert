# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Programname, type: :model do
  let(:programname) { FactoryBot.create(:programname) }

  it { is_expected.to have_many(:program).dependent(:restrict_with_exception) }

  #  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(200) }
  it { is_expected.to validate_length_of(:previousname).is_at_most(200) }
  it { is_expected.to validate_length_of(:comment).is_at_most(200) }

  it 'can be created' do
    FactoryBot.create(:programname)
  end

  it '-name_with_id' do
    programname_with_id = '[ ID ' + programname.id.to_s + ' ] ' + programname.name
    expect(programname_with_id).to eq programname.name_with_id
  end

  # Shortened, abbreviated name
  it '-short' do
    shortened_name = if programname.name.length > Programname::ABBREVIATION_LENGTH

                       programname.name[0..len] + '...'

                     else

                       programname.name

                     end

    expect(shortened_name).to eq(programname.short)
  end

  # Alias
  it '-short_name' do
    expect(programname.short_name).to eq(programname.short)
  end
end
