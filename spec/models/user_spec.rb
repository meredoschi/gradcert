require 'rails_helper'

RSpec.describe User, type: :model do
  #  pending "add some examples to (or delete) #{__FILE__}"

  it 'has a kind' do
    #    pap_local_admin_permission = FactoryBot.create(:permission, :paplocaladm)

    #    user = FactoryBot.create(:user, permission: pap_local_admin_permission )

    user = FactoryBot.create(:user, :paplocaladm)

    user_kind = user.kind

    expect(user_kind).to eq(user.kind)

    puts user.kind
  end

  it 'can be created' do
    print I18n.t('activerecord.models.user').capitalize + ': '
    user = FactoryBot.create(:user, :paplocaladm)
    puts user.email
  end
end
