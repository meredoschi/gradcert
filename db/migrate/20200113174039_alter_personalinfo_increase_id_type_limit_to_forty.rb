# frozen_string_literal: true

# Increased due to the international version
class AlterPersonalinfoIncreaseIdTypeLimitToForty < ActiveRecord::Migration
  def up
    change_column :personalinfos, :idtype, :string, limit: 40 # for the future
    # I18n.t('activerecord.constants.personalinfo.idtype.registered_foreigner').length = 20
  end

  def down
    change_column :personalinfos, :idtype, :string, limit: 15
  end
end
