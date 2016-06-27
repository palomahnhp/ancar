class CreateTotalIndicators < ActiveRecord::Migration
  def change

    create_table :indicator_groups do |t|
      t.string :description
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :total_indicators do |t|
      t.belongs_to :indicator_metric, index: true, foreign_key: true
      t.belongs_to :indicator_group, index: true, foreign_key: true
      t.string :indicator_type

      t.string :updated_by
      t.timestamps null: false
    end

  end
end
