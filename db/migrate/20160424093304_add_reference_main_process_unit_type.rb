class AddReferenceMainProcessUnitType < ActiveRecord::Migration
  def change
    add_reference :main_processes, :unit_type, index: true
  end
end
