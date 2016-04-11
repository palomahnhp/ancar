class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    	t.belongs_to :subprocess, index: true, foreign_key: true
      t.text :description

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
