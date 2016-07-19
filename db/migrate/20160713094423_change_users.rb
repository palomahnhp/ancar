class ChangeUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.rename :string, :email
      t.rename :ayre, :login
      t.rename :first_surname, :surname
    end
  end

  def down
    change_table :users do |t|
      t.rename :login, :ayre
      t.rename :surname, :first_surname
    end
  end
end
