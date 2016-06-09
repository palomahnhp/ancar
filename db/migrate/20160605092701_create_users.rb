class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ayre
      t.integer :uweb_id
      t.string :name
      t.string :first_surname
      t.string :second_surname
      t.string :document_number
      t.string :document_type
      t.integer :pernr
      t.string  :phone
      t.string  :official_position, :string

      t.timestamps null: false
    end

    create_table :administrators do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end

    create_table :managers do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end

    create_table :valuators do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
