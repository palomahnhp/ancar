class CreateAssignedEmployeesChanges < ActiveRecord::Migration
  def change
    create_table :assigned_employees_changes do |t|
      t.belongs_to :period, index: true, foreign_key: true
      t.belongs_to :unit, index: true, foreign_key: true
      t.text :justification
      t.date :justified_at
      t.string :justified_by
      t.date :verified_at,  index:true
      t.string :verified_by
    end
  end
end
