# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Incicializar BD Arranque Distritos:
#  - db:seed -> incluye llamada a
#       - import:distritos - UnidadesDistritos.xls  -> carga unidades distritos partiendo Directorio
#       - import:procesos  - procesos_distritos_2015.xls  ->
#  - import:indicadores - Carga/Distritos/99999999_nombre_distrito.xls
#  - total_indicators:load - Sumandos.xls
#  - stats:agregar_indicadores --> genera summary_processes
#
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

#puts "1. Creando settings"

  Setting.create!(key: "header_logo", value: "Logo Ayuntamiento de Madrid")
  Setting.create!(key: "org_name", value: "Ayuntamiento de Madrid")
  Setting.create!(key: "app_name", value: "Evaluación de la carga de trabajo")
  Setting.create!(key: "logger_name", value: "ancar.log")
  Setting.create!(key: "logger_status", value: 1)
  Setting.create!(key: "logger_age", value: "weekle")

#puts "2. Creando tipos de organizaciones"
  to1 = OrganizationType.create!(acronym: "JD", description: "Distritos",
                 updated_by: "seed")
  to2 = OrganizationType.create!(acronym: "SGT", description: "Secretarías Generales Técnicas",
                 updated_by: "seed")
  to3 = OrganizationType.create!(acronym: "AG", description: "Áreas de Gobierno",
                 updated_by: "seed")
  to4 = OrganizationType.create!(acronym: "OOAA", description: "Organismos Autónomos",
                 updated_by: "seed")

#puts "3. Creando Tipos de unidades para Distritos"
  ut1 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS JURIDICOS", organization_type_id: to1.id, order: 1, updated_by: "seed")
  ut2 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS TECNICOS", organization_type_id: to1.id, order: 2, updated_by: "seed")
  ut3 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS ECONOMICOS", organization_type_id: to1.id, order: 3, updated_by: "seed")
  ut4 = UnitType.create!(description: "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS", organization_type_id: to1.id, order: 4, updated_by: "seed")
  ut5 = UnitType.create!(description: "SECCION DE EDUCACION", organization_type_id: to1.id, order: 5, updated_by: "seed")
  ut6 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SOCIALES", organization_type_id: to1.id, order: 6, updated_by: "seed")
  ut7 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO", organization_type_id: to1.id, order: 7, updated_by: "seed")
  ut8 = UnitType.create!(description: "SECRETARIA DE DISTRITO", organization_type_id: to1.id, order: 8, updated_by: "seed")

#puts "5. Cargando datos Periodo 2015 Distritos"
#  pdo1 = Period.create!(organization_type_id: to1.id, description: "PERIODO DE ANÁLISIS: AÑO 2015",
#                 started_at: "01/01/2015", ended_at: "31/12/2015",
#                 opened_at: "01/04/2016", closed_at: "30/04/2016",
#                 updated_by: "seed")

#puts "6. Cargando grupos de personal"
  OfficialGroup.create!(name: "A1", description: "Grupo A1")
  OfficialGroup.create!(name: "A2", description: "Grupo A2")
  OfficialGroup.create!(name: "C1", description: "Grupo C1")
  OfficialGroup.create!(name: "C2", description: "Grupo C2")
  OfficialGroup.create!(name: "Agrup.",  description: "Agrupación de Categorias Profesionales")

# puts "Cargando SummaryTypes y TotalIndicatorTypes
  process     = Item.create!(item_type: "summary_type", description: "Proceso", updated_by: "initialize")
  subprocess  = Item.create!(item_type: "summary_type", description: "Subproceso", updated_by: "initialize")
  stock       = Item.create!(item_type: "summary_type", description: "Stock", updated_by: "initialize")
  sub_subprocess = Item.create!(item_type: "summary_type", description: "Sub-subproceso", updated_by: "initialize")
  control     = Item.create!(item_type: "summary_type", description: "Control", updated_by: "initialize")

  pr = SummaryType.create(acronym: "P", item_id:process.id,     order: 1, updated_at:
      'initialize', active: true)
  s  = SummaryType.create(acronym: "S", item_id:subprocess.id,  order: 2, updated_at:
      'initialize', active: true)
  u  = SummaryType.create(acronym: "U", item_id:stock.id,       order: 4, updated_at: 'initialize',  active: true)
  g  = SummaryType.create(acronym: "G", item_id:sub_subprocess.id, order: 3, updated_at: 'initialize',  active: false)
  c  = SummaryType.create(acronym: "C", item_id:control.id,     order: 5, updated_at: 'initialize',  active: false)

  it = Item.create!(item_type: "total_indicator_type", description: "No acumula", updated_by: "initialize")
  TotalIndicatorType.create(item_id: it.id, acronym: '-',order: 1, updated_at: 'initialize', active: true)
  it = Item.create!(item_type: "total_indicator_type", description: "Acumula", updated_by: "initialize")
  TotalIndicatorType.create(item_id: it.id, acronym: 'A',order: 5, updated_at: 'initialize', active: true)
  it = Item.create!(item_type: "total_indicator_type", description: "Entrada", updated_by: "initialize")
  TotalIndicatorType.create(item_id: it.id, acronym: 'E',order: 2, updated_at: 'initialize', active: true)
  it = Item.create!(item_type: "total_indicator_type", description: "Salida", updated_by: "initialize")
  TotalIndicatorType.create(item_id: it.id, acronym: 'S',order: 3, updated_at: 'initialize', active: true)
  it = Item.create!(item_type: "total_indicator_type", description: "Único", updated_by: "initialize")
  TotalIndicatorType.create(item_id: it.id, acronym: 'U',order: 4, updated_at: 'initialize', active: true)



