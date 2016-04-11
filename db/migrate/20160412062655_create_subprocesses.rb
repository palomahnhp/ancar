class CreateSubprocesses < ActiveRecord::Migration
  def change
    create_table :subprocesses do |t|
    	t.belongs_to :mainprocess, index: true, foreign_key: true
      t.string :description
      
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
