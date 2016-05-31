class AddEmployeesAssignedToUnitAndSubprocess < ActiveRecord::Migration
  def change
   create_table :official_groups do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end

    create_table :assigned_employees do |t|
      t.integer  :staff_of_id
      t.string   :staff_of_type
      t.belongs_to :official_groups
      t.string :updated_by
      t.decimal :quantity, :precision => 5, :scale => 2

      t.timestamps null: false
    end
  end
end
