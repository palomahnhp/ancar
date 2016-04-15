class AddReferencesToMasterTables < ActiveRecord::Migration
  def change
    add_reference :indicators, :task, polymorphic: true, index: true
    add_reference :tasks, :sub_process, polymorphic: true, index: true
    add_reference :sub_processes, :main_process, polymorphic: true, index: true
    add_reference :main_processes, :period, polymorphic: true, index: true

    add_reference :indicator_sources, :indicator, polymorphic: true, index: true
    add_reference :indicator_sources, :source, polymorphic: true, index: true

    add_reference :periods, :organization_type, polymorphic: true
    add_reference :units, :organization, polymorphic: true, index: true
    add_reference :units, :unit_type, polymorphic: true, index: true
    add_reference :organizations, :organization_type, polymorphic: true, index: true
    add_reference :unit_types, :organization_type, polymorphic: true, index: true
  end
end
