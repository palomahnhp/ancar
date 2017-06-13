class AddImportedToSources < ActiveRecord::Migration
  def change
    add_column :sources, :imported, :boolean
  end
end
