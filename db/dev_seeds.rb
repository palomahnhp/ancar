require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts '1. Creando settings'
Setting.create!(key: 'header_logo', value: 'Logo Ayuntamiento de Madrid')
Setting.create!(key: 'org_name', value: 'Ayuntamiento de Madrid')
Setting.create!(key: 'app_name', value: 'Evaluación de la carga de trabajo')

puts '2. Cargando grupos de personal'
OfficialGroup.create!(name: 'A1', description: 'Grupo A1')
OfficialGroup.create!(name: 'A2', description: 'Grupo A2')
OfficialGroup.create!(name: 'C1', description: 'Grupo C1')
OfficialGroup.create!(name: 'C2', description: 'Grupo C2')
OfficialGroup.create!(name: 'E',  description: 'Grupo E')

puts '3. Creando tipos de organizaciones'
to1 = OrganizationType.create!(acronym: 'JD', description: 'Distritos',updated_by: 'seed')
to2 = OrganizationType.create!(acronym: 'SGT', description: 'Secretarías Generales Técnicas',updated_by: 'seed')

puts '4. Creando Tipos de unidades'
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS JURIDICOS', organization_type_id: to1.id, order: 1, updated_by: 'seed')
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS TECNICOS', organization_type_id: to1.id, order: 2, updated_by: 'seed')
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS ECONOMICOS', organization_type_id: to1.id, order: 3, updated_by: 'seed')
UnitType.create!(description: 'UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', organization_type_id: to1.id, order: 4, updated_by: 'seed')
UnitType.create!(description: 'SECCION DE EDUCACION', organization_type_id: to1.id, order: 5, updated_by: 'seed')
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS SOCIALES', organization_type_id: to1.id, order: 6, updated_by: 'seed')
UnitType.create!(description: 'DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO', organization_type_id: to1.id, order: 7, updated_by: 'seed')
UnitType.create!(description: 'SECRETARIA DE DISTRITO', organization_type_id: to1.id, order: 8, updated_by: 'seed')
UnitType.create!(description: 'SECRETARIA GENERAL TÉCNICA', organization_type_id: to2.id, order: 1, updated_by: 'seed')

puts '5. Creando organizaciones'

(1..21).each do |n|
  Organization.create!(organization_type_id: to1.id, description: "Junta de Distrito #{n}",
  short_description: "JD #{n}", sap_id: (10000000 + n))
end

(1..8).each do |n|
  Organization.create!(organization_type_id: to2.id, description: "Secretaria General Área #{n}",
  short_description: "SGT #{n}", sap_id: (10000000 + n))
end

puts '6. Creando unidades'
# Distritos
UnitType.all.each do |u|
  Organization.where(organization_type_id: to1.id).each do |o|
    un = Unit.create!(description_sap: u.description, organization_id: o.id, unit_type_id: u.id, updated_by: 'seed')
  end
end

puts '7. Metricas y Fuentes'
item = Item.create!(item_type: 'metric', description: 'nº de contratos')
Metric.create!(item_id: item.id)
item = Item.create!(item_type: 'metric', description: 'nº de expedientes')
Metric.create!(item_id: item.id)
item = Item.create!(item_type: 'metric', description: 'nº de elementos')
Metric.create!(item_id: item.id)
item = Item.create!(item_type: 'metric', description: 'nº de llamadas')

item = Item.create!(item_type: 'source', description: 'SAP')
Source.create!(item_id: item.id)
item = Item.create!(item_type: 'source', description: 'SIGSA')
Source.create!(item_id: item.id)
item = Item.create!(item_type: 'source', description: 'Interno')
Source.create!(item_id: item.id)
item = Item.create!(item_type: 'source', description: 'AVISA')

puts '8. Cargando datos Periodo 2015 Distritos'
periodo = Period.create!(organization_type_id: to1.id, description: 'PERIODO DE ANÁLISIS',
                         started_at: (Time.now - 1.year).at_beginning_of_year,
                         ended_at: (Time.now - 1.year).at_beginning_of_year,
                         opened_at: (Time.now - 1.month), closed_at: (Time.now + 1.month),
                         updated_by: 'seed')

# main_processes
(1..3).each do |i|
  item = Item.create!(item_type: 'main_process', description: Faker::Lorem.sentence.truncate(60))
  mp = periodo.main_processes.create!(order: i, item_id: item.id,
  created_at: rand((Time.now - 1.week) .. Time.now))
  puts "  #{mp.item.description}"

  item_task = Item.create!(item_type: 'task', description: Faker::Lorem.sentence.truncate(10))
  UnitType.where(id: 1..3).each do |ut|
    #sub_processes
    (1..rand(0..3)).each do |i|
      item = Item.create!(item_type: 'sub_process', description: Faker::Lorem.sentence.truncate(50))
      sp = mp.sub_processes.create!(unit_type_id: ut.id, order: i, item_id: item.id,
      created_at: rand((Time.now - 1.week) .. Time.now))
      puts "   #{sp.item.description}"
      task = sp.tasks.create(item_id: item_task.id, order: i)
      # indicators
      (1..rand(1..4)).each do |i|
        item = Item.create!(item_type: 'indicator', description: Faker::Lorem.sentence.truncate(28))
        ind = task.indicators.create!(order: i,
        item_id: item.id,
        created_at: rand((Time.now - 1.week) .. Time.now))
        puts "     #{ind.item.description}"
        # indicator_metric
        (1..rand(1..2)).each do |i|
          ind.indicator_metrics.create!(metric_id: rand(1..Metric.count))
        end
        # indicator_source
        (1..rand(1..3)).each do |i|
          ind.indicator_sources.create!(source_id: rand(1..Source.count))
        end
      end
    end
  end
end

puts '9. Creando entry_indicators'

IndicatorMetric.all.each do |im|
  Unit.where(unit_type_id: 1).each do |unit|
    im.entry_indicators.create!(unit_id: unit.id, amount: rand(0..500.99), period_id: periodo.id)
  end
end

puts '10. Creando totalizadores'

puts '  Inicializando summary_types'
  process     = Item.create!(item_type: 'summary_type', description: 'Proceso', updated_by: 'initialize')
  subprocess  = Item.create!(item_type: 'summary_type', description: 'Subproceso', updated_by: 'initialize')
  stock       = Item.create!(item_type: 'summary_type', description: 'Stock', updated_by: 'initialize')

  pr = SummaryType.create(acronym: 'P', item_id:process.id,     order: 1, updated_at: 'initialize', active: TRUE)
  s  = SummaryType.create(acronym: 'S', item_id:subprocess.id,  order: 2, updated_at: 'initialize', active: TRUE)
  u  = SummaryType.create(acronym: 'U', item_id:stock.id,       order: 4, updated_at: 'initialize',  active: TRUE)

puts 'inicializando total_indicators'
  it = Item.create!(item_type: 'total_indicator_type', description: 'No acumula', updated_by: 'initialize')
  TotalIndicatorType.create(item_id: it.id, acronym: '-',order: 1, updated_at: 'initialize', active: TRUE)
  it = Item.create!(item_type: 'total_indicator_type', description: 'Entrada', updated_by: 'initialize')
  TotalIndicatorType.create(item_id: it.id, acronym: 'E',order: 2, updated_at: 'initialize', active: TRUE)
  it = Item.create!(item_type: 'total_indicator_type', description: 'Salida', updated_by: 'initialize')
  TotalIndicatorType.create(item_id: it.id, acronym: 'S',order: 3, updated_at: 'initialize', active: TRUE)
  it = Item.create!(item_type: 'total_indicator_type', description: 'Único', updated_by: 'initialize')
  TotalIndicatorType.create(item_id: it.id, acronym: 'U',order: 4, updated_at: 'initialize', active: TRUE)

  puts '11. Empleados asignados'

  OfficialGroup.all.each do |og|
    Unit.all.each do |u|
      unit_quantity = sum = 0
      u.unit_type.sub_processes.all.each do |sp|
        sp.assigned_employees.create!(official_group_id: og.id, staff_of_id: sp.id, staff_of_type: 'SubProcess',
        quantity: rand(0..2.2), unit_id: u.id, period_id: periodo.id)
      end
      sum = AssignedEmployee.where(official_group_id: og.id, staff_of_type: 'SubProcess', unit_id: u.id, period_id: periodo.id).sum(:quantity)

      AssignedEmployee.create!(official_group_id: og.id, staff_of_id: u.id, staff_of_type: 'Unit', quantity: sum,
                                       unit_id: u.id, period_id: periodo.id)
    end
  end

puts '12. Creando usuarios '

  user  = User.create!(login: 'ADM001', name: 'Usuario', surname: 'Administrador', second_surname: 'IAM',
                       uweb_id: rand(70000..90000), pernr: rand(70000..90000), official_position: Faker::Company.profession)
  user.add_role :admin
  puts " #{user.login}"

  user = User.create!(login: 'MAN001', name: 'Usuario', surname: 'Gestor', second_surname: 'Planificación',
                      uweb_id: rand(70000..90000), pernr: rand(70000..90000),
                      official_position: Faker::Company.profession)

  user.add_role :manager
  puts " #{user.login}"

  user = User.create!(login: 'VAL001', name: 'Usuario', surname: 'Validador', second_surname: 'Distrito 1',
                      uweb_id: rand(70000..90000), pernr: rand(70000..90000),
                      official_position: Faker::Company.profession)
  user.add_role(:valuator, Organization.where(organization_type: to1.id).first)
  puts " #{user.login}"
  user = User.create!(login: 'USU001', name: 'Usuario', surname: 'Distrito', second_surname: '1',
                      uweb_id: rand(70000..90000), pernr: rand(70000..90000),
                      official_position: Faker::Company.profession)
  user.add_role(:user, Organization.where(organization_type: to1.id).first)
  puts " #{user.login}"

  user = User.create!(login: 'VAL002', name: 'Usuario', surname: 'Validador', second_surname: 'Distrito 2',
                      uweb_id: rand(70000..90000), pernr: rand(70000..90000),
                      official_position: Faker::Company.profession)
  user.add_role(:valuator, Organization.where(organization_type: to1.id).second)
  puts " #{user.login}"
  user = User.create!(login: 'USU002', name: 'Usuario', surname: 'Distrito', second_surname: '2',
                      uweb_id: rand(70000..90000), pernr: rand(70000..90000),
                      official_position: Faker::Company.profession)
  user.add_role(:user, Organization.where(organization_type: to1.id).second)
  puts " #{user.login}"

