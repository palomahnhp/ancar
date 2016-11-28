class CreateTotalIndicatorType < ActiveRecord::Migration
  def change
    create_table :total_indicator_types do |t|
      t.belongs_to :item, index: true, foreign_key: true
      t.string     :acronym
      t.integer    :order
      t.boolean    :active

      t.string     :updated_by
      t.timestamps null: false
    end
  end
end
