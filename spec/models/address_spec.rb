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

  # For Brazilian (or similar) address formats
  it '-mailing' do
    street_addr = address.street_name + ', ' + address.streetnum.to_s + ' - ' + address.complement
    mailing_address = [street_addr, address.neighborhood, address.city_and_state,
                       address.post_code_i18n].join(' - ')
    expect(mailing_address).to eq(address.mailing)
  end

  it '-with_complement' do
    address_w_complement = [address.streetname.designation, address.addr, address.streetnum,
                            address.complement].join(' ')
    expect(address_w_complement).to eq(address.with_complement)
  end

  it '-with_complement_intl' do
    address_w_complement_intl = [address.streetnum, address.addr, address.streetname.designation,
                                 address.complement].join(' ')
    expect(address_w_complement_intl).to eq(address.with_complement_intl)
  end

  it '-without_complement' do
    address_sans_complement = [address.streetname.designation, address.addr,
                               address.streetnum].join(' ')
    expect(address_sans_complement).to eq(address.without_complement)
  end

  it '-without_complement_intl' do
    address_sans_complement_intl = [address.streetnum, address.addr,
                                    address.streetname.designation].join(' ')
    expect(address_sans_complement_intl).to eq(address.without_complement_intl)
  end
  # Possible to do: use denormalized data if and when implemented in the municipalities controller
  it '-city_and_state' do
    municipality = address.municipality
    state = municipality.stateregion.state
    address_city_state = municipality.name + ' (' + state.abbreviation + ')'
    expect(address_city_state).to eq(address.city_and_state)
  end

  it 'can be created' do
    print I18n.t('activerecord.models.address').capitalize + ': '
    address = FactoryBot.create(:address)
    puts address.id.to_s
  end

  it '-postal_code_prefix' do
    post_code_prefix = if address.postalcode.include? '-'

                         address.postalcode.chomp.split('-').first.to_i

                       else

                         0

                       end

    expect(post_code_prefix).to eq(address.postal_code_prefix)
  end

  it '-postal_code_suffix' do
    post_code_suffix = if address.postalcode.include? '-'

                         address.postalcode.chomp.split('-').last

                       else
                         ' '

                       end
    expect(post_code_suffix).to eq address.postal_code_suffix
  end

  it '-street' do
    streetname = address.streetname
    addr = address.addr
    streetnum = address.streetnum
    complement = address.complement

    street_address = if complement.present?
                       [streetname.designation, addr, streetnum, complement].join(' ')
                     elsif streetname.id.present?
                       [streetname.designation, addr, streetnum].join(' ')
                     else
                       [addr, streetnum].join(' ')
                     end

    expect(street_address).to eq(address.street)
  end

  # International version
  it '-street_intl' do
    streetname = address.streetname
    addr = address.addr
    streetnum = address.streetnum
    complement = address.complement

    street_address_intl = if complement.present?
                            [streetnum, addr, streetname.designation, complement].join(' ')
                          elsif streetname.id.present?
                            [streetnum, addr, streetname.designation].join(' ')
                          else
                            [streetnum, addr].join(' ')
                          end

    expect(street_address_intl).to eq(address.street_intl)
  end

  it '-street_number (alias to streetnumber)' do
    expect(address.street_number).to eq(address.streetnum)
  end

  # CNAB - G032 - Brazilian bank payment (text file generation)
  it '-street_name' do
    street_name_addr = [address.streetname.designation, address.addr].join(' ')
    expect(street_name_addr).to eq(address.street_name)
  end

  it '-municipality_name' do
    city_name = address.municipality.name
    expect(city_name).to eq(address.municipality_name)
  end

  it '-post_code_i18n' do
    i18n_postal_code = I18n.t('activerecord.attributes.address.postalcode') + ' ' + \
                       address.postalcode
    expect(i18n_postal_code).to eq(address.post_code_i18n)
  end

  it '-postal_addr' do
    street_name = [address.streetname.designation, address.addr].join(' ')
    postal_address = street_name + ', ' + address.streetnum.to_s + ' - ' + address.complement
    expect(postal_address).to eq(address.postal_addr)
  end
end
