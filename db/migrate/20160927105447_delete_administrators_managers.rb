class DeleteAdministratorsManagers < ActiveRecord::Migration
  def up
    drop_table :administrators
    drop_table :managers
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
