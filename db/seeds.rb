
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ description: 'Chicago' }, { description: 'Copenhagen' }])
#   Mayor.create(description: 'Emanuel', city: cities.first)
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts "1. Creando settings"
  Setting.create!(key: "header_logo", value: "Logo Ayuntamiento de Madrid")
  Setting.create!(key: "org_name", value: "Ayuntamiento de Madrid")
  Setting.create!(key: "app_name", value: "Evaluación de la carga de trabajo")

puts "2. Creando tipos de organizaciones"
  to1 = OrganizationType.create!(acronym: "JD", description: "Junta de Distrito",
                 updated_by: "seed")
  to2 = OrganizationType.create!(acronym: "SGT", description: "Secretaria General Técnica",
                 updated_by: "seed")
  to3 = OrganizationType.create!(acronym: "AG", description: "Áreas de Gobierno",
                 updated_by: "seed")
  to4 = OrganizationType.create!(acronym: "OOAA", description: "Organismos Autónomos",
                 updated_by: "seed")

puts "5. Insertando datos de Distritos en organizations"
    o1 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CENTRO", short_description: "CEN JMD CENTRO", sap_id: "10000002", updated_by: "seed")
    o2 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA", short_description: "ARG JMD ARGANZUELA", sap_id: "10000003", updated_by: "seed")
    o3 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE RETIRO", short_description: "RET JMD RETIRO", sap_id: "10000004", updated_by: "seed")
    o4 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE SALAMANCA", short_description: "SAL JMD SALAMANCA", sap_id: "10000005", updated_by: "seed")
    o5 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CHAMARTIN", short_description: "CHM JMD CHAMARTIN", sap_id: "10000006", updated_by: "seed")
    o6 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE TETUAN", short_description: "TET JMD TETUAN", sap_id: "10000007", updated_by: "seed")
    o7 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CHAMBERI", short_description: "CHB JMD CHAMBERI", sap_id: "10000008", updated_by: "seed")
    o8 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE FUENCARRAL-EL PARDO", short_description: "FUE JMD FUENCARRAL", sap_id: "10000009", updated_by: "seed")
    o9 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE MONCLOA-ARAVACA", short_description: "MON JMD MONCLOA", sap_id: "10000010", updated_by: "seed")
    o10 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE LATINA", short_description: "LAT JMD LATINA", sap_id: "10000011", updated_by: "seed")
    o11 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CARABANCHEL", short_description: "CAR JMD CARABANCHEL", sap_id: "10000012", updated_by: "seed")
    o12 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE USERA", short_description: "USE JMD USERA", sap_id: "10000013", updated_by: "seed")
    o13 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE PUENTE DE VALLECAS", short_description: "VAL JMD PUENTE  VALLECAS", sap_id: "10000014", updated_by: "seed")
    o14 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE MORATALAZ", short_description: "MOR JMD MORATALAZ", sap_id: "10000015", updated_by: "seed")
    o15 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CIUDAD LINEAL", short_description: "C.L JMD CIUDAD LINEAL", sap_id: "10000016", updated_by: "seed")
    o16 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE HORTALEZA", short_description: "HOR JMD HORTALEZA", sap_id: "10000017", updated_by: "seed")
    o17 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE VILLAVERDE", short_description: "VIL JMD VILLAVERDE", sap_id: "10000018", updated_by: "seed")
    o18 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE VILLA DE VALLECAS", short_description: "VAV JMD VILLA DE VALLECAS", sap_id: "10000019", updated_by: "seed")
    o19 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE VICALVARO", short_description: "VIC JMD VICALVARO", sap_id: "10000020", updated_by: "seed")
    o20 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE SAN BLAS CANILLEJAS", short_description: "SBC JMD SAN BLAS CANILLEJAS", sap_id: "10000021", updated_by: "seed")
    o21 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS", short_description: "BAR JMD BARAJAS", sap_id: "10000022", updated_by: "seed")

puts "6. Creando Tipos de unidades para Distritos"
  ut1 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS JURÍDICOS", organization_type_id: to1.id, updated_by: "seed")
  ut2 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS TÉCNICOS", organization_type_id: to1.id, updated_by: "seed")
  ut3 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS ECONÓMICOS", organization_type_id: to1.id, updated_by: "seed")
  ut4 = UnitType.create!(description: "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS", organization_type_id: to1.id, updated_by: "seed")
  ut5 = UnitType.create!(description: "SECCIÓN DE EDUCACIÓN", organization_type_id: to1.id, updated_by: "seed")
  ut6 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SOCIALES", organization_type_id: to1.id, updated_by: "seed")
  ut7 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO", organization_type_id: to1.id, updated_by: "seed")
  ut8 = UnitType.create!(description: "SECRETARÍA DEL DISTRITO", organization_type_id: to1.id, updated_by: "seed")

puts "7. Creando unidades para Distritos"
  UnitType.where(organization_type_id: to1.id).each do |u|
    Organization.where(organization_type_id: to1.id).each do |o|
      Unit.create!(description_sap: u.description, organization_id: o.id, unit_type_id: u.id, updated_by: "seed")
    end
  end

puts "8. Cargando datos Periodo 2015 Distritos"
  pdo1 = Period.create!(organization_type_id: to1.id, description: "Datos correspondientes a 2015",
                 started_at: "01/01/2015", ended_at: "31/12/2015",
                 opened_at: "01/04/2016", closed_at: "30/04/2016",
                 updated_by: "seed")
