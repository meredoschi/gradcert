# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  #  Address(id: integer, streetname_id: integer, addr: string, complement: string,
  #  neighborhood: string, municipality_id: integer, postalcode: string,
  #  institution_id: integer, country_id: integer, contact_id: integer,
  #  regionaloffice_id: integer, program_id: integer, header: string, course_id: integer,
  #  internal: boolean, council_id: integer, streetnum: integer, bankbranch_id: integer)

  let(:address) { FactoryBot.create(:address) }
  context 'internal deparment or subsidiary address' do
    before { allow(subject).to receive(:internal).and_return(true) }
    it { should validate_presence_of(:header) }
    it { is_expected.to validate_length_of(:header).is_at_most(120) }
  end

  context 'regular (main) postal address' do
    before { allow(subject).to receive(:internal).and_return(false) }
    it { is_expected.to validate_presence_of(:addr) }
    it { is_expected.to validate_length_of(:addr).is_at_most(200) }
    it { is_expected.to validate_length_of(:neighborhood).is_at_most(50) }
    it { is_expected.to validate_length_of(:postalcode).is_at_least(5) }
    it { is_expected.to validate_length_of(:postalcode).is_at_most(15) }
    it { is_expected.to validate_presence_of(:streetname_id) }
    it { is_expected.to validate_presence_of(:municipality_id) }
    it { is_expected.to allow_value('01234-567').for(:postalcode) }
    it { is_expected.not_to allow_value('123 45').for(:postalcode) }
  end
  #
  # validates :streetname_id, presence: true, unless: :skip_validation
  # validates :municipality_id, presence: true, unless: :skip_validation
  #
  # validates_format_of :postalcode, with: /[0-9]{5}-[0-9]{3}/, unless: :skip_validation
  #

  # Normalized version (slower)
  it '-state_abbreviation' do
    address_state_abbrev = address.municipality.stateregion.state.abbreviation
    expect(address_state_abbrev).to eq(address.state_abbreviation)
  end

  it '-mailing (domestic)' do
    address = FactoryBot.create(:address)

    street_name = [address.streetname.designation, address.addr].join(' ')
    street_addr = street_name + ', ' + address.streetnum.to_s + ' - ' + address.complement
    neighborhood = address.neighborhood

    city_and_state = address.municipality.name + ' (' + address.state_abbreviation + ')'

    postal_code = I18n.t('activerecord.attributes.address.postalcode') + ' ' + address.postalcode
    mailing_address = [street_addr, neighborhood, city_and_state, postal_code].join(' - ')

    expect(mailing_address).to eq(address.mailing)

    puts mailing_address
  end

  it "-correspondence ('international' mailing address with country)" do
    address = FactoryBot.create(:address)

    country = address.municipality.stateregion.state.country.name
    # http://stackoverflow.com/questions/12237431/the-law-of-demeter

    correspondence_address = [address.mailing, country].join(' - ')

    expect(correspondence_address).to eq(address.correspondence)
  end

  it 'can be created' do
    print I18n.t('activerecord.models.address').capitalize + ': '
    address = FactoryBot.create(:address)
    puts address.id.to_s
  end

  it '-postal_code_prefix' do
    if address.postalcode.include? '-'

      address.postalcode.chomp.split('-').first.to_i

    else

      0

    end
  end

  it '-postal_code_suffix' do
    if address.postalcode.include? '-'

      address.postalcode.chomp.split('-').last

    else
      ' '

    end
  end

  it '-street' do
    streetname = address.streetname
    addr = address.addr
    streetnum = address.streetnum
    complement = address.complement

    if complement.present?
      [streetname.designation, addr, streetnum, complement].join(' ')
    elsif streetname.id.present?
      [streetname.designation, addr, streetnum].join(' ')
    else
      [addr, streetnum].join(' ')
    end
  end

  it '-street_number (alias to streetnumber)' do
    address_street_number = address.streetnum
    expect(address_street_number).to eq(address.streetnum)
  end
end
