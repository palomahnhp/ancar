class CreateMetrics < ActiveRecord::Migration
  def change
      create_table :metrics do |t|
      t.belongs_to :item, index: true

      t.string :updated_by
      t.timestamps null: false
    end
    change_table :indicators do |t|
      t.belongs_to :metric, index: true
      t.remove :metric
    end
  end
end
