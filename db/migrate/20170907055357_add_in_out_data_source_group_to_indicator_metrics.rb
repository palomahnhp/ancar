class AddInOutDataSourceGroupToIndicatorMetrics < ActiveRecord::Migration
  def change
    add_column :indicator_metrics, :in_out_type, :string
    add_column :indicator_metrics, :validation_group_id, :integer
    add_column :indicator_metrics, :data_source, :string
    add_column :indicator_metrics, :procedure, :string
  end
end
