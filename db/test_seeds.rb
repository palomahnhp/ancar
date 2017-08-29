require 'database_cleaner'

# puts 'Test_seed - inicialización datos Distritos'
# '1 Create_organizations '
organization_type = OrganizationType.find_by_acronym("JD")
organization_data = [
["JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA","10000003", "1"],
["JUNTA MUNICIPAL DEL DISTRITO DE CENTRO","10000003", "3"],
["JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS","10000022", "2"] ]

UnitType.find_or_create_by!(description: 'DEPARTAMENTO DE SERVICIOS JURIDICOS', organization_type_id: organization_type, order: 1, updated_by: 'seed')
UnitType.find_or_create_by!(description: 'DEPARTAMENTO DE SERVICIOS TECNICOS', organization_type_id: organization_type, order: 2, updated_by: 'seed')
UnitType.find_or_create_by!(description: 'DEPARTAMENTO DE SERVICIOS ECONOMICOS', organization_type_id: organization_type, order: 3, updated_by: 'seed')

organization_data.each do |data|
  organization = Organization.find_or_create_by!(organization_type_id: organization_type.id,
  description: data[0],
  sap_id: data[1],
  order: data[2] )

  sap_id = 10200100

  UnitType.where(organization_type_id: organization_type.id).order(:id).each_with_index do |unit_type, index|
    Unit.create!(unit_type_id: unit_type.id, organization_id: organization.id,
                 description_sap: unit_type.description, sap_id: sap_id + index, order: index + 1)
  end

end

# '2. Create period'
period = Period.find_or_create_by!(description: 'Periodo de análisis de datos Distritos', organization_type_id: organization_type.id,
                        started_at: (Time.now - 1.year).beginning_of_year, ended_at: (Time.now - 1.year).end_of_year,
                        opened_at:  (Time.now + 1.month), closed_at: (Time.now + 1.month))

# '4 Crear procesos'

mp1 = MainProcess.find_or_create_by!(period_id: period.id, item_id: Item.find_or_create_by!(item_type: "main_process",
description: "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS").id,
order: "1")
sp1 = SubProcess.find_or_create_by!(main_process_id: mp1.id, unit_type_id: 1,
item_id: Item.find_or_create_by!(item_type: "sub_process",
description: "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO").id,
order: "1")
sp2 = SubProcess.find_or_create_by!(main_process_id: mp1.id, unit_type_id: 1,
item_id: Item.find_or_create_by!(item_type: "sub_process",
description: "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO").id,
order: "2")

task_item = Item.find_or_create_by!(item_type: "task", description: "TAREA")
task = Task.find_or_create_by!(sub_process_id: sp1.id, item_id: task_item.id, order: "1")

indicator_item = Item.find_or_create_by!(item_type: "indicator", description: "Contratos Menores")
indicator = Indicator.find_or_create_by!(task_id: task.id, item_id: indicator_item.id, order: "1", code: '1')
metric_item = Item.find_or_create_by!(item_type: "metric", description: "Nº de Contratos recibidos")
metric = Metric.find_or_create_by!(item_id: metric_item.id)
indicator_metric = IndicatorMetric.find_or_create_by!(indicator_id: indicator.id, metric_id: metric.id)

source_item = Item.find_or_create_by!(item_type: "source", description: "SIGSA")
source = Source.find_or_create_by!(item_id: source_item.id)
indicator_source = IndicatorSource.find_or_create_by!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)

summary_types = SummaryType.all.map{|st| [st.acronym, st.id] }

indicator_metric.total_indicators.find_or_create_by!(indicator_type: summary_types[0][0], in_out: 'E', summary_type_id: summary_types[0][1])
indicator_metric.total_indicators.find_or_create_by!(indicator_type: summary_types[2][0], in_out: 'U', summary_type_id: summary_types[2][1])

metric_item = Item.find_or_create_by!(item_type: "metric", description: "Nº de Contratos tramitados")
metric = Metric.find_or_create_by!(item_id: metric_item.id)
indicator_metric = IndicatorMetric.find_or_create_by!(indicator_id: indicator.id, metric_id: metric.id)
indicator_metric.total_indicators.find_or_create_by!(indicator_type: summary_types[1][0], in_out: 'S', summary_type_id: summary_types[1][1])
indicator_source = IndicatorSource.find_or_create_by!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)
# SP2
task = Task.find_or_create_by!(sub_process_id: sp2.id, item_id: task_item.id, order: "1")
indicator_item = Item.find_or_create_by!(item_type: "indicator", description: "Expedientes urbanísticos")
indicator = Indicator.find_or_create_by!(task_id: task.id, item_id: indicator_item.id, order: "1", code: '1')
metric_item = Item.find_or_create_by!(item_type: "metric", description: "Nº de Expedientes")
metric = Metric.find_or_create_by!(item_id: metric_item.id)
indicator_metric = IndicatorMetric.find_or_create_by!(indicator_id: indicator.id, metric_id: metric.id)

source_item = Item.find_or_create_by!(item_type: "source", description: "PLYCA")
source = Source.find_or_create_by!(item_id: source_item.id)
indicator_source = IndicatorSource.find_or_create_by!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)

mp2 = MainProcess.find_or_create_by!(period_id: period.id,
item_id: Item.find_or_create_by!(item_type: "main_process", description: "AUTORIZACIONES Y CONCESIONES").id,
order: "2")

# puts 'Test_seed - inicialización datos SGT '

# '1 Create_organizations'
organization_type = OrganizationType.find_by_acronym("SGT")

# '2. Create period'
period = Period.create(description: "Periodo de análisis de datos SGT #{organization_type.id}", organization_type_id: organization_type.id,
                       started_at: (Time.now - 1.year).beginning_of_year, ended_at: (Time.now - 1.year).end_of_year,
                       opened_at:  (Time.now + 1.month), closed_at: (Time.now + 1.month))

# '3. Create organizations'
organization_data = [
    ["SECRETARIA GENERAL TECNICA DEL AREA DE GOBIERNO DE DESARROLLO URBANO SOSTENIBLE","10005748", "1"],
    ["SECRETARIA GENERAL TECNICA AG MEDIO AMBIENTE Y MOVILIDAD","10005782", "3"],
    ["SECRETARIA GENERAL TECNICA GERENCIA DE LA CIUDAD","10005875", "2"] ]

ut = UnitType.find_or_create_by!(description: 'SECRETARIA GENERAL TECNICA', organization_type_id: organization_type.id, order: 1, updated_by: 'seed')

organization_data.each do |data|
  organization = Organization.find_or_create_by!(organization_type_id: organization_type.id,
                                      description: data[0],
                                      sap_id: data[1],
                                      order: data[2] )
  sap_id = 10200200

  UnitType.where(organization_type_id: organization_type.id).order(:id).each_with_index do |unit_type, index|
    Unit.find_or_create_by!(unit_type_id: unit_type.id, organization_id: organization.id,
                 description_sap: unit_type.description, sap_id: sap_id + index, order: index + 1)
  end


  # '4 Crear bloques competenciales'

  mp1 = MainProcess.find_or_create_by!(period_id: period.id, item_id: Item.find_or_create_by!(item_type: "main_process",
                                                                        description: "RÉGIMEN JURÍDICO").id,
                            order: "1")
  sp1 = SubProcess.find_or_create_by!(main_process_id: mp1.id, unit_type_id: ut.id,
                           item_id: Item.find_or_create_by!(item_type: "sub_process",
                                                 description: "ASUNTOS JUNTA GOBIERNO, PLENO Y COMISIONES DEL PLENO").id,
                           order: "1")
  sp2 = SubProcess.find_or_create_by!(main_process_id: mp1.id, unit_type_id: ut.id,
                           item_id: Item.find_or_create_by!(item_type: "sub_process",
                                                 description: "PROYECTOS NORMATIVOS").id,
                           order: "2")

  task_item = Item.find_or_create_by!(item_type: "task", description: "TAREA")
  task = Task.find_or_create_by!(sub_process_id: sp1.id, item_id: task_item.id, order: "1")

  indicator_item = Item.find_or_create_by!(item_type: "indicator", description: "- Revisión jurídica, preparación de documentación y petición de inforems de los asuntos a tratar en la Comisión Preparatoria ..
")
  indicator = Indicator.find_or_create_by!(task_id: task.id, item_id: indicator_item.id, order: "1", code: "1")
  metric_item = Item.find_or_create_by!(item_type: "metric", description: "Nº informes solicitados por otras Áreas de Gobierno")
  metric = Metric.find_or_create_by!(item_id: metric_item.id)
  indicator_metric = IndicatorMetric.find_or_create_by!(indicator_id: indicator.id, metric_id: metric.id)

  source_item = Item.find_or_create_by!(item_type: "source", description: "Elaboración propia")
  source = Source.find_or_create_by!(item_id: source_item.id)
  indicator_source = IndicatorSource.find_or_create_by!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)


  metric_item = Item.find_or_create_by!(item_type: "metric", description: "Nº de asuntos tratados en la Junta de Gobierno")
  metric = Metric.find_or_create_by!(item_id: metric_item.id)
  indicator_metric = IndicatorMetric.find_or_create_by!(indicator_id: indicator.id, metric_id: metric.id)
  indicator_source = IndicatorSource.find_or_create_by!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)

  # SP2
  task = Task.find_or_create_by!(sub_process_id: sp2.id, item_id: task_item.id, order: "1")
  indicator_item = Item.find_or_create_by!(item_type: "indicator", description: "Preparación revisión y tramitación de proyectos normativos ....")
  indicator = Indicator.find_or_create_by!(task_id: task.id, item_id: indicator_item.id, order: "1", code: '1')
  metric_item = Item.find_or_create_by!(item_type: "metric", description: "Nº de proyectos de otras Áreas")
  metric = Metric.find_or_create_by!(item_id: metric_item.id)
  indicator_metric = IndicatorMetric.find_or_create_by!(indicator_id: indicator.id, metric_id: metric.id)

  source_item = Item.find_or_create_by!(item_type: "source", description: "Elaboración Propia")
  source = Source.find_or_create_by!(item_id: source_item.id)
  indicator_source = IndicatorSource.find_or_create_by!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)

  mp2 = MainProcess.find_or_create_by!(period_id: period.id,
                            item_id: Item.find_or_create_by!(item_type: "main_process", description: "RÉGIMEN INTERIOR").id,
                            order: "2")

end

