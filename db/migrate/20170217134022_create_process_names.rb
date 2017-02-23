class CreateProcessNames < ActiveRecord::Migration
  def change
    create_table :process_names do |t|

      t.belongs_to :organization_type, index: true, foreign_key: true
      t.string     :model
      t.string     :name

      t.string     :updated_by
      t.timestamps null: false
    end
  end
end
