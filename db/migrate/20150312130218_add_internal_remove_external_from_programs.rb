class AddInternalRemoveExternalFromPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :internal, :boolean, default: true
    remove_column('programs', 'externalvenue')
  end
end
