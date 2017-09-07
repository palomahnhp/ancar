namespace :indicator_metrics do
  require 'spreadsheet'

  desc 'Initialize code for a range of regs, mode: order/reg --- '
  task initialize_code: :environment do
#   Rango de resgistros a tratar
    inicio = ENV['init'].to_i
    fin    = ENV['end'].to_i

#   Mode:  indica como se actualizan el nuevo campo code partiendo de order o del id del registro:
    mode   = ENV['mode']

    p 'Initializing indicator code between: ' + inicio.to_s + '-' + fin.to_s + ' ,update mode: ' + mode
    (inicio..fin).each do |i|
      indicator = Indicator.find_by(id: i)
      unless indicator.nil?
        p '...updating reg: ' + indicator.id.to_s
        if mode == 'order'
          indicator.code = indicator.order
        elsif mode == 'reg'
          indicator.code = indicator.id
        end
        indicator.save
      end
    end
  end

 end

