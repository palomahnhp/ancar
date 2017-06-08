module Supervisor::ReportsHelper

  def total_indicators(mp_id)
    MainProcess.find(mp_id).indicadores
    puts 's'
  end
end
