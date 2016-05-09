class CreateEntryIndicators < ActiveRecord::Migration
  def change
    create_table :entry_indicators do |t|
      t.belongs_to :unit, index: true
      t.belongs_to :indicator, index: true
      t.belongs_to :indicator_sources, index: true
      t.text :specifications
      t.string :updated_by

      t.timestamps null: false
    end
  end
end
