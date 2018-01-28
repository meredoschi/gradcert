require 'rails_helper'

describe Extra, type: :helper do

  let(:gross_amount) { 1200 }

  it { expect( helper.hello ).to eq "hello" }

  it "calculates social security taxes" do
#  def self.calculate_social_security(base_amount, taxation)

    taxation = FactoryBot.create(:taxation, :personal)

    social_security_due=Extra.calculate_social_security(gross_amount, taxation)

    puts social_security_due.to_s

    expect( helper.calculate_social_security(gross_amount, taxation) ).to eq social_security_due

#      base_amount*taxation.socialsecurity/100

  end

end
