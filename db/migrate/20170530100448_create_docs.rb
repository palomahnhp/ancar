class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :format
      t.string :role

      t.string :updated_by
      t.timestamps null: false
    end
  end
end
