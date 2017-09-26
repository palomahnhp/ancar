class BudgetProgram < ActiveRecord::Base
  belongs_to :budget_section
  belongs_to :organization
end
