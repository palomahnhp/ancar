class DeleteValuators < ActiveRecord::Migration
  def up
    drop_table :valuators
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
