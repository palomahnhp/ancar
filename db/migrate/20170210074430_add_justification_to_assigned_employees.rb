class AddJustificationToAssignedEmployees < ActiveRecord::Migration
  change_table :assigned_employees do |t|
    t.text :justification
    t.date :justified_at
    t.string :justified_by
    t.boolean :pending_verification
    t.date :verified_at,  index:true
    t.string :verified_by
  end
end
