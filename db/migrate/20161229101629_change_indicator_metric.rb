class ChangeIndicatorMetric < ActiveRecord::Migration
  def change
    add_column :indicator_metrics,:order, :string
    add_reference :indicator_sources, index: true, foreign_key: true
  end
end
