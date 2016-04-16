class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :description
      t.string :type
      t.integer :amount
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
