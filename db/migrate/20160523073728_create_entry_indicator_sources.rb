class CreateEntryIndicatorSources < ActiveRecord::Migration
  def change
    create_table :entry_indicator_sources do |t|
      t.belongs_to :entry_indicator_id, index: true
      t.belongs_to :source, index: true
    end
  end
end
