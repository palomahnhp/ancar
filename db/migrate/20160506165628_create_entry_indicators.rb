class CreateEntryIndicators < ActiveRecord::Migration

  def change
    create_table :entry_indicators do |t|
      t.belongs_to :unit, index: true, foreign_key: true
      t.belongs_to :indicator_metric, index: true, foreign_key: true
      t.belongs_to :indicator_source, index: true, foreign_key: true
      t.text :specifications
      t.column :amount, :integer
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :entry_indicator_sources do |t|
      t.belongs_to :entry_indicator, index: true, foreign_key: true
      t.belongs_to :source, index: true, foreign_key: true
      t.decimal :amount, :precision => 12, :scale => 2
      t.string :updates_by

      t.timestamps null: false
    end
  end
end
