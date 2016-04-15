class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
    	t.belongs_to :task, index: true, foreign_key: true
      t.string :indicator_in
      t.string :indicator_out      
      t.belongs_to :source ,index: true, foreign_key: true
      t.integer :amount 
      
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end

=====================================
 rails d migration create_periods
 rails d migration create_indicators 
 rails d migration create_sources 
 rails d migration create_tasks
 rails d migration create_sub_processes
 rails d migration create_main_processes
 rails d migration create_organizations
 rails d migration create_subtype_organizations
 rails d migration create_type_organizations
 rails d migration create_main_organizations
 rails d migration create_indicator_sources

=======================================
 rails g migration create_sources 
 rails g migration create_periods
 rails g migration create_type_organizations

 rails g migration create_main_processes
 rails g migration create_subtype_organization
 rails g migration create_main_organizations

 rails g migration create_sub_processes
 rails g migration create_organizations

 rails g migration create_tasks

 rails g migration create_indicators 

 ==========================================

