class BudgetExecution < ActiveRecord::Base
  belongs_to :budget_program
  belongs_to :budget_section
  belongs_to :budget_chapter
end
