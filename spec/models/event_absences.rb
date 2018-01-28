require 'rails_helper'

RSpec.describe Event, type: :model do
  #  let(:event) { FactoryBot.create(:event, :absence) }

  let(:event) { FactoryBot.create(:event) }

  # Validations

  #  it { should validate_presence_of(:registration_id) }

  it 'can be created' do
    #    print I18n.t('activerecord.models.event').capitalize+': '
    #    event = FactoryBot.create(:event)
    #    puts event.name
  end

  it '-absence?' do
    event_absence_status = event.absence?

    expect(event_absence_status).to eq(event.absence?)
  end
end
