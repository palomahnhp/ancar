class ChangeEntryIndicatorSources < ActiveRecord::Migration
  def change
    change_table :entry_indicator_sources do |t|
      t.remove :entry_indicator_id_id
      t.belongs_to :entry_indicator, index: true
    end
  end
end
