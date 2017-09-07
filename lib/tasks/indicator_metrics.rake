namespace :indicator_metrics do
  require 'spreadsheet'

  desc "Initialize in_out_type  "
  task initialize_in_out_type: :environment do
    p 'Parameters: save: ' + ENV['save'] + ' entorno: ' + ENV['RAILS_ENV'] unless ENV['RAILS_ENV'].nil?
    p 'Initializing indicators in_out_type, updating ' + TotalIndicator.where(summary_type_id: [17, 18]).count.to_s + '... '
    count = 0
    TotalIndicator.where(summary_type_id: [17, 18]).each do |ti|
      im = IndicatorMetric.find_by(id: ti.indicator_metric_id)
      unless im.nil?
        im.in_out_type = ti.summary_type_id == 17 ? ti.in_out : 'X'
        im.save
        count += 1
      end
    end
    p count.to_s + ' regs updated'
  end

  desc "Initialize validation group  "
  task initialize_group: :environment do
    p 'Initializing validation group, regs ' + TotalIndicator.where(summary_type_id: 19).count.to_s + '... '
    count = 0
    TotalIndicator.where(summary_type_id: 19).each do |ti|
      im = IndicatorMetric.find_by(id: ti.indicator_metric_id)
      unless im.nil?
        im.validation_group_id = ti.indicator_group_id
        im.save
        count += 1
      end
    end
    p '... ' + count.to_s + ' regs updated'
  end
 end

