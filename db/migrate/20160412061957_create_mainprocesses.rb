class CreateMainprocesses < ActiveRecord::Migration
  def change
    create_table :mainprocesses do |t|
    	t.belongs_to :period, index: true, foreign_key: true
      t.string :description

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
