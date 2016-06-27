class CreateProcessMasterTables < ActiveRecord::Migration
  def change

    create_table :periods do |t|
      t.belongs_to :organization_type,  index:true,  foreign_key: true
      t.string :description, limit: 100,  index:true
      t.date :started_at,  index:true
      t.date :ended_at
      t.date :opened_at
      t.date :closed_at
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :items do |t|
      t.string  :item_type
      t.string :description
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :main_processes do |t|
      t.belongs_to :period, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :sub_processes do |t|
      t.belongs_to :main_process, index: true, foreign_key: true
      t.belongs_to :unit_type, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :tasks do |t|
      t.belongs_to :sub_process, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :indicators do |t|
      t.belongs_to :task, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :sources do |t|
      t.belongs_to :item, index: true, foreign_key: true
      t.boolean :fixed
      t.boolean :has_specification
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

   create_table :metrics do |t|
      t.belongs_to :item, index: true, foreign_key: true
      t.string :in_out

      t.string :updated_by
      t.timestamps null: false
    end

    create_table :indicator_sources do |t|
      t.belongs_to :indicator, index: true, foreign_key: true
      t.belongs_to :source, index: true, foreign_key: true
    end

    create_table :indicator_metrics do |t|
      t.belongs_to :indicator, index: true, foreign_key: true
      t.belongs_to :metric, index: true, foreign_key: true
    end

  end
end
