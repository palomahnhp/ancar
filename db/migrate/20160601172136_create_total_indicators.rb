class CreateTotalIndicators < ActiveRecord::Migration
  def change
    create_table :total_indicators do |t|
      t.belongs_to :indicator_metric
      t.string :type
      t.belongs_to :sub_process_group
      t.string :updated_by

      t.timestamps null: false
    end

    change_table :indicator_metrics do |t|
      t.remove :total_process
      t.remove :total_sub_process
    end

    create_table :indicator_groups do |t|
      t.string :description
      t.string :updated_by

      t.timestamps null: false
    end
  end
end
