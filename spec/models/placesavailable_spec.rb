# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Placesavailable, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  it 'can be created' do
    print I18n.t('activerecord.models.placesavailable').capitalize + ': '
    placesavailable = FactoryBot.create(:placesavailable)
    puts placesavailable.name
  end

  it 'summary (virtual attribute)' do
    sep = '; '

    placesavailable = FactoryBot.create(:placesavailable)

    virtual_attrib = '['

    virtual_attrib += I18n.t('activerecord.attributes.placesavailable.accredited').downcase + ' '

    accredited = placesavailable.accredited

    # Was nill in 2017
    virtual_attrib += if accredited.nil?

                        I18n.t('undefined_value') + sep

                      else

                        accredited.to_s + sep

                      end

    virtual_attrib += I18n.t('activerecord.attributes.placesavailable.requested').downcase + ' '

    requested = placesavailable.requested

    # Was nill in 2017
    virtual_attrib += if requested.nil?

                        I18n.t('undefined_value') + sep

                      else

                        requested.to_s + sep

                      end

    virtual_attrib += I18n.t('activerecord.attributes.placesavailable.authorized').downcase + ' '

    authorized = placesavailable.authorized

    # Allow for nil cases due to unavailable data in 2017
    virtual_attrib += if authorized.nil?

                        I18n.t('undefined_value')

                      else

                        authorized.to_s

                      end

    virtual_attrib += ']'

    puts '-summary'
    print '  '
    puts virtual_attrib

    expect(virtual_attrib).to eq(placesavailable.summary)
  end
end
