namespace :stats do

  desc "Generate summary indicators for graphics"
  task agregar_indicadores: :environment do
    SummaryProcessIndicator.delete_all
    SummaryProcessDetail.delete_all
    SummaryProcess.delete_all
    TotalIndicator.all.each do |ti|
      process_total_indicator(ti)
    end
    puts "Finalizada agregación de indicadores"
  end
end

private
  def process_total_indicator(ti)
    puts "  -- TI: #{ti.id} #{ti.indicator_type} "

    im  = ti.indicator_metric
    mp  = im.indicator.task.sub_process.main_process
    sp  = im.indicator.task.sub_process

    eis = EntryIndicator.where(indicator_metric: im.id)
    staff_involved = Array.new(0)
    eis.each do |ei|
      org = ei.unit.organization
      staff_involved << sp.id
      if    ti.indicator_type == 'S'
        p_type = sp.class.to_s
        p_id = sp.id
        p_description = sp.item.description
      elsif ti.indicator_type == 'P'
        p_type = mp.class.to_s
        p_id = mp.id
        p_description = mp.item.description
      elsif ti.indicator_type == 'U'

        p_type = org.class.to_s
        p_id = org.id
        p_description = org.description
 #       staff_involved << o.sub_processes.ids
#  DA ERROR AL REALZIAR CREATE PENDIENTE
        next
       else
        puts "    == ERROR tipo indicador no existe #{ti.indicator_type}"
        next
      end

      sm_p = SummaryProcess.where(process_type: p_type, process_id: p_id).first
      if sm_p.nil?
        description = p_type.constantize.find(p_id).item.description
        sm_p = SummaryProcess.create!(process_type: p_type, process_id: p_id, process_description: description, updated_by: 'stats')
      end

      sm_ind = SummaryProcessIndicator.create!(
           summary_process_id: sm_p.id, indicator: im.indicator.item.description,
           metric: im.metric.item.description, updated_by: 'stats')

     ae = AssignedEmployee.where(staff_of_type: "SubProcess", staff_of_id: staff_involved).group(:official_group_id).sum(:official_group_id)

     sm_details = SummaryProcessDetail.where(summary_process_id: sm_p.id, unit_id: org.id, sub_process_id: sp.id).first
     if sm_details.nil?
        sm_details = SummaryProcessDetail.create!(summary_process_id: sm_p.id, unit_id: org.id,
                   sub_process_id: sp.id, amount: ei.amount,
                   A1: ae[1], A2: ae[2], C1: ae[3], C2: ae[4], E: ae[5], updated_by: 'stats')
     else
       sm_details.amount = sm_details.amount + ei.amount
       sm_details.save
     end
    end
  end