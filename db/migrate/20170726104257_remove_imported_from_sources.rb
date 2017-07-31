class RemoveImportedFromSources < ActiveRecord::Migration
  def change
    remove_column :sources, :imported
  end
end
