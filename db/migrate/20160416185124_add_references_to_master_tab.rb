class AddReferencesToMasterTab < ActiveRecord::Migration
  def change
    add_reference :indicators, :task, index: true
    add_reference :tasks, :sub_process, index: true
    add_reference :sub_processes, :main_process, index: true
    add_reference :main_processes, :period, index: true

    add_reference :indicator_sources, :indicator, index: true
    add_reference :indicator_sources, :source, index: true

    add_reference :periods, :organization_type, index: true
    add_reference :units, :organization, index: true
    add_reference :units, :unit_type, index: true
    add_reference :organizations, :organization_type, index: true
    add_reference :unit_types, :organization_type, index: true
  end
end
