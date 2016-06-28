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

#    staff_involved = Array.new(0)
    eis.each do |ei|
      org = ei.unit.organization
#      staff_involved << sp.id
      if    ti.indicator_type == 'S'
        p_type = sp.class.to_s
        p_ids = "(#{sp.id})"
        p_id = sp.id
        p_description = sp.item.description
      elsif ti.indicator_type == 'P'
        p_type = mp.class.to_s
        p_id = mp.id
        p_ids ="("
        mp.sub_processes.ids.each do |id|
         p_ids << "#{id}, "
        end

        p_ids[p_ids.length - 2] = ")"
        p_description = mp.item.description
      elsif ti.indicator_type == 'U'
        p_type = org.class.to_s
        p_id = org.id
        p_description = org.description
        next
       else
        puts "    == ERROR tipo indicador no existe #{ti.indicator_type}"
        next
      end

      sm_p = SummaryProcess.where(process_type: p_type, process_id: p_id).take
      if sm_p.nil?
        puts "... procesando #{p_type} #{p_description}"
        description = p_type.constantize.find(p_id).item.description
        sm_p = SummaryProcess.create!(process_type: p_type, process_id: p_id, process_description: description, updated_by: 'stats')
      end
      sm_ind = SummaryProcessIndicator.where(summary_process_id: sm_p.id, indicator: im.indicator.item.description,
           metric: im.metric.item.description).take
      if sm_ind.nil?
        sm_ind = SummaryProcessIndicator.create!(
           summary_process_id: sm_p.id, indicator: im.indicator.item.description,
           metric: im.metric.item.description, updated_by: 'stats')
      end

      # Se comprueba si ya existe el detalle para ese summaryProcess:
      #  - NO existe -> se crea y se calculan los efecitvos del subproceso y se añade el amount
      #  - SI existe -> se recupera y acumula el amount

      sm_details = SummaryProcessDetail.where(summary_process_id: sm_p.id, unit_id: org.id).take
      if sm_details.nil?
        p_type = sp.class.to_s if ti.indicator_type == 'P'
        puts "Amount: 0   #{ei.indicator_metric.indicator.item.description} #{ei.amount}"
        sql = " SELECT units.organization_id,
                       organizations.description,
                       assigned_employees.official_group_id,
                       sum(assigned_employees.quantity) AS quantity
                FROM public.assigned_employees,
                     public.units,
                     public.organizations
                WHERE assigned_employees.unit_id = units.id
                  AND units.organization_id = organizations.id
                  AND staff_of_type = '#{p_type}'
                  AND staff_of_id in #{p_ids}
                  AND units.organization_id = #{org.id}
                GROUP BY units.organization_id,
                       organizations.description,
                       assigned_employees.official_group_id
                 ORDER BY units.organization_id ASC,
                          organizations.description,
                          assigned_employees.official_group_id ASC"
        ae = ActiveRecord::Base.connection.execute(sql)
        sm_details = SummaryProcessDetail.create!(summary_process_id: sm_p.id, unit_id: org.id,
                       sub_process_id: sp.id, amount: ei.amount, A1: ae[0]["quantity"], A2: ae[1]["quantity"],
                       C1: ae[2]["quantity"], C2: ae[3]["quantity"], E: ae[4]["quantity"])
      else
        sm_details.amount += ei.amount
        sm_details.save
      end
    end
  end
