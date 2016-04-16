class FixDateColumns < ActiveRecord::Migration
  def change
    change_table :periods do |t|
      t.rename :initial_date, :start_at
      t.rename :final_date,   :end_at
      t.rename :opening_date, :open_at
      t.rename :closing_date, :close_at
    end
  end
end
