class AddCodeToIndicatorsAndIndicatorMetric < ActiveRecord::Migration
  def change
    add_column :indicators, :code, :integer
    add_column :indicator_metrics, :code, :integer
  end
end
