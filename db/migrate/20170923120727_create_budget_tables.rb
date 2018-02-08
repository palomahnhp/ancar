class CreateBudgetTables < ActiveRecord::Migration
  def change
    create_table :budget_sections do |t|
      t.integer :year
      t.string :code
      t.string :description
    end

    create_table :budget_programs do |t|
      t.integer :year
      t.string :code
      t.string :description
      t.belongs_to :budget_section, index: true, foreign_key: true
      t.belongs_to :organization, index: true, foreign_key: true
    end

    create_table :budget_chapters do |t|
      t.integer :year
      t.string :code
      t.string :description
    end
    create_table :budget_executions do |t|
      t.integer :year

      t.string :economic_code
      t.string :economic_description
      t.belongs_to :budget_section, index: true, foreign_key: true
      t.belongs_to :budget_program, index: true, foreign_key: true
      t.belongs_to :budget_chapter, index: true, foreign_key: true

      t.decimal :credit_initial,      precision: 15, scale: 2
      t.decimal :credit_modification, precision: 15, scale: 2
      t.decimal :credit_definitive,   precision: 15, scale: 2
      t.decimal :credit_available,    precision: 15, scale: 2
      t.decimal :credit_disponible,   precision: 15, scale: 2
      t.decimal :credit_authorized,   precision: 15, scale: 2
      t.decimal :credit_willing,      precision: 15, scale: 2

      t.decimal :obligation_recognized, precision: 15, scale: 2
      t.decimal :payment_ordered,     precision: 15, scale: 2
      t.decimal :payment_performed,   precision: 15, scale: 2

    end

  end
end

t.belongs_to :period
t.belongs_to :unit
t.string     :key
t.string     :title
t.text       :message
t.text       :data_errors

t.string     :updated_by
t.timestamps null: false
t.timestamps null: false