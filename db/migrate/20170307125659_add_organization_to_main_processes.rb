class AddOrganizationToMainProcesses < ActiveRecord::Migration
  def change
    add_reference :main_processes, :organization, index: true, foreign_key: true
  end
end
