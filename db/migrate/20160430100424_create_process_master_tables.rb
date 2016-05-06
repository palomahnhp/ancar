class CreateProcessMasterTables < ActiveRecord::Migration
  def change

    create_table :periods do |t|
      t.belongs_to :organization_type,  index:true
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
      t.belongs_to :period, index:true
      t.belongs_to :item, index:true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :sub_processes do |t|
      t.belongs_to :main_process, index:true
      t.belongs_to :unit_type, index:true
      t.belongs_to :item, index:true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :tasks do |t|
      t.belongs_to :sub_process, index:true
      t.belongs_to :item, index:true
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :indicators do |t|
      t.belongs_to :task, index:true
      t.belongs_to :item, index:true
      t.boolean :in
      t.boolean :out
      t.string :metric
      t.integer :order
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :sources do |t|
      t.belongs_to :indicator, index:true
      t.belongs_to :item, index:true
      t.boolean :fixed
      t.boolean :has_specification
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :indicators_sources do |t|
      t.belongs_to :indicator, index:true
      t.belongs_to :source, index:true
    end
  end
end
