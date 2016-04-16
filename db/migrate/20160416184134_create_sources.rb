class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.boolean :specification
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
