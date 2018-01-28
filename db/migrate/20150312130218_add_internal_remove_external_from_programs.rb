class AddInternalRemoveExternalFromPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :internal, :boolean, default: true
    remove_column('programs', 'externalvenue')
  end
end
