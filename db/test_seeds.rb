require 'database_cleaner'

# '1 Create_organizations'
organization_type = OrganizationType.first
organization_data = [
["JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA","10000003", "1"],
["JUNTA MUNICIPAL DEL DISTRITO DE CENTRO","10000003", "3"],
["JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS","10000022", "2"] ]

UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS JURIDICOS', organization_type_id: organization_type, order: 1, updated_by: 'seed')
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS TECNICOS', organization_type_id: organization_type, order: 2, updated_by: 'seed')
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS ECONOMICOS', organization_type_id: organization_type, order: 3, updated_by: 'seed')

organization_data.each do |data|
  organization = Organization.create!(organization_type_id: organization_type.id,
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
period = Period.create(description: 'Periodo de análisis de datos', organization_type_id: organization_type.id,
                        started_at: (Time.now - 1.year).beginning_of_year, ended_at: (Time.now - 1.year).end_of_year,
                        opened_at:  (Time.now - 1.year).end_of_year + 1.day, closed_at:  (Time.now - 1.year).end_of_year + 1.month)

# '4 Crear procesos'

mp1 = MainProcess.create!(period_id: period.id, item_id: Item.create!(item_type: "main_process",
description: "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS").id,
order: "1")
sp1 = SubProcess.create!(main_process_id: mp1.id, unit_type_id: 1,
item_id: Item.create!(item_type: "sub_process",
description: "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO").id,
order: "1")
sp2 = SubProcess.create!(main_process_id: mp1.id, unit_type_id: 1,
item_id: Item.create!(item_type: "sub_process",
description: "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO").id,
order: "2")

task_item = Item.create!(item_type: "task", description: "TAREA")
task = Task.create!(sub_process_id: sp1.id, item_id: task_item.id, order: "1")

indicator_item = Item.create!(item_type: "indicator", description: "Contratos Menores")
indicator = Indicator.create!(task_id: task.id, item_id: indicator_item.id, order: "1")
metric_item = Item.create!(item_type: "metric", description: "Nº de Contratos recibidos")
metric = Metric.create!(item_id: metric_item.id)
indicator_metric = IndicatorMetric.create!(indicator_id: indicator.id, metric_id: metric.id)

source_item = Item.create!(item_type: "source", description: "SIGSA")
source = Source.create!(item_id: source_item.id)
indicator_source = IndicatorSource.create!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)

summary_types = SummaryType.all.map{|st| [st.acronym, st.id] }

indicator_metric.total_indicators.create!(indicator_type: summary_types[0][0], in_out: 'E', summary_type_id: summary_types[0][1])
indicator_metric.total_indicators.create!(indicator_type: summary_types[2][0], in_out: 'U', summary_type_id: summary_types[2][1])

metric_item = Item.create!(item_type: "metric", description: "Nº de Contratos tramitados")
metric = Metric.create!(item_id: metric_item.id)
indicator_metric = IndicatorMetric.create!(indicator_id: indicator.id, metric_id: metric.id)
indicator_metric.total_indicators.create!(indicator_type: summary_types[1][0], in_out: 'S', summary_type_id: summary_types[1][1])
indicator_source = IndicatorSource.create!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)
# SP2
task = Task.create!(sub_process_id: sp2.id, item_id: task_item.id, order: "1")
indicator_item = Item.create!(item_type: "indicator", description: "Expedientes urbanísticos")
indicator = Indicator.create!(task_id: task.id, item_id: indicator_item.id, order: "1")
metric_item = Item.create!(item_type: "metric", description: "Nº de Expedientes")
metric = Metric.create!(item_id: metric_item.id)
indicator_metric = IndicatorMetric.create!(indicator_id: indicator.id, metric_id: metric.id)

source_item = Item.create!(item_type: "source", description: "PLYCA")
source = Source.create!(item_id: source_item.id)
indicator_source = IndicatorSource.create!(indicator_id: indicator.id, indicator_metric_id: indicator_metric.id, source_id: source.id)

mp2 = MainProcess.create!(period_id: period.id,
item_id: Item.create!(item_type: "main_process", description: "AUTORIZACIONES Y CONCESIONES").id,
order: "2")


