class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :order
      t.text :description
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
