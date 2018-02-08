class CreateValidations < ActiveRecord::Migration
  def change
    create_table :validations do |t|
      t.belongs_to :period
      t.belongs_to :unit
      t.string     :key
      t.string     :title
      t.text       :message
      t.text       :data_errors

      t.string     :updated_by
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
