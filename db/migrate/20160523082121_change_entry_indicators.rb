class ChangeEntryIndicators < ActiveRecord::Migration
    def change
      change_table :entry_indicators do |t|
        t.remove :indicator_sources_id
        t.column :amount, :integer
      end
  end
end
