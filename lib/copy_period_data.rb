class CopyPeriodData
  require "logger"

  def initialize(id_destino, id_origen)
     @logger_status ? Setting['logger:status'] : '0'
     if @logger_status == 1
       @logger = Logger.new(Setting['logger_name'], Setting['logger_age'])
       @logger.level = Setting['logger_level']
     end
     debugger
     @period_destino = Period.find(id_destino)
     if !@period_destino
       @logger.error("CopyPeriodData#initialize") {"Error: Periodo a poblarr no existe, id: #{id_destino}" } if @logger_status == 1
       true
     else
       @period_origen = Period.find(id_origen)
       if @period_origen && @period_origen.main_process.count > 0
         @logger.info("CopyPeriodData#initialize") {"Success" } if @logger_status == 1
         true
       else
         @logger.error("CopyPeriodData#initialize") {"Error: periodo no existe o no tiene procesos asociados, id: #{id_origen}" } if @logger_status == 1
         false
       end
     end
  end

  def clone
    @period_destino.deep_clone include: :main_processes
    debugger
  end

end