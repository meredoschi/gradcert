# frozen_string_literal: true

require 'rails_helper'

describe ApplicationpermissionsHelper, type: :helper do
  let(:permission) { FactoryBot.create(:permission) }
  let(:user) { FactoryBot.create(:user, :pap) }

  it '-permission_for(user)' do
    user_permission_kind = user.permission.kind
    expect(user_permission_kind).to eq(helper.permission_for(user))
  end
end
