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

puts "1. Creando settings"

  Setting.create!(key: "header_logo", value: "Logo Ayuntamiento de Madrid")
  Setting.create!(key: "org_name", value: "Ayuntamiento de Madrid")
  Setting.create!(key: "app_name", value: "Evaluación de la carga de trabajo")

puts "2. Creando tipos de organizaciones"
  to1 = OrganizationType.create!(acronym: "JD", description: "Distritos",
                 updated_by: "seed")
  to2 = OrganizationType.create!(acronym: "SGT", description: "Secretarías Generales Técnicas",
                 updated_by: "seed")
  to3 = OrganizationType.create!(acronym: "AG", description: "Áreas de Gobierno",
                 updated_by: "seed")
  to4 = OrganizationType.create!(acronym: "OOAA", description: "Organismos Autónomos",
                 updated_by: "seed")

puts "3. Creando Tipos de unidades para Distritos"
  ut1 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS JURIDICOS", organization_type_id: to1.id, order: 1, updated_by: "seed")
  ut2 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS TECNICOS", organization_type_id: to1.id, order: 2, updated_by: "seed")
  ut3 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS ECONOMICOS", organization_type_id: to1.id, order: 3, updated_by: "seed")
  ut4 = UnitType.create!(description: "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS", organization_type_id: to1.id, order: 4, updated_by: "seed")
  ut5 = UnitType.create!(description: "SECCION DE EDUCACION", organization_type_id: to1.id, order: 5, updated_by: "seed")
  ut6 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SOCIALES", organization_type_id: to1.id, order: 6, updated_by: "seed")
  ut7 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO", organization_type_id: to1.id, order: 7, updated_by: "seed")
  ut8 = UnitType.create!(description: "SECRETARIA DE DISTRITO", organization_type_id: to1.id, order: 8, updated_by: "seed")

puts "5. Cargando datos Periodo 2015 Distritos"
  pdo1 = Period.create!(organization_type_id: to1.id, description: "PERIODO DE ANÁLISIS: AÑO 2015",
                 started_at: "01/01/2015", ended_at: "31/12/2015",
                 opened_at: "01/04/2016", closed_at: "30/04/2016",
                 updated_by: "seed")

puts "6. Cargando grupos de personal"
  OfficialGroup.create!(name: "A1", description: "Grupo A1")
  OfficialGroup.create!(name: "A2", description: "Grupo A2")
  OfficialGroup.create!(name: "C1", description: "Grupo C1")
  OfficialGroup.create!(name: "C2", description: "Grupo C2")
  OfficialGroup.create!(name: "E",  description: "Grupo E")
