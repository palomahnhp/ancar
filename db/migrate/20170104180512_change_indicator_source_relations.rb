class ChangeIndicatorSourceRelations < ActiveRecord::Migration
  def change
    change_table :indicator_sources do |t|
      t.belongs_to :indicator_metric, index: true, foreign_key: true
    end
  end
end
