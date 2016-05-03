require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts "Creando settings"
  Setting.create!(key: "header_logo", value: "Análisis de la carga de trabajo")
  Setting.create!(key: "org_name", value: "Ayuntamiento de Madrid")
  Setting.create!(key: "app_name", value: "Análisis de la carga de trabajo")

puts "Creando items"
  (1..5).each do |i|
    descripcion = Faker::Lorem.sentence(3).truncate(60)
    item = Item.create!(item_type: "main_process", description: descripcion, updated_by: 'dev_seed')
  end

  (1..5).each do |i|
    descripcion = Faker::Lorem.sentence(3).truncate(60)
    item = Item.create!(item_type: "sub_process", description: descripcion, updated_by: 'dev_seed')
  end
  (1..5).each do |i|
    descripcion = Faker::Lorem.sentence(3).truncate(60)
    item = Item.create!(item_type: "task", description: descripcion, updated_by: 'dev_seed')
  end

  (1..5).each do |i|
    descripcion = Faker::Lorem.sentence(3).truncate(60)
    item = Item.create!(item_type: "indicator", description: descripcion, updated_by: 'dev_seed')
  end


puts "Creando tipos de organizaciones"
  to = OrganizationType.create!(acronym: "JD", name: "Junta de Distrito",
                 updated_by: "ev_seed")
  tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS JURÍDICOS", organization_type_id: to.id)
  tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS TÉCNICOS", organization_type_id: to.id)
  tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS ECONÓMICOS", organization_type_id: to.id)
  tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO", organization_type_id: to.id)
  tu = UnitType.create!(name: "SECCIÓN DE EDUCACIÓN", organization_type_id: to.id)
  tu = UnitType.create!(name: "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS", organization_type_id: to.id)
  tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS SOCIALES", organization_type_id: to.id)


  to1 = OrganizationType.create!(acronym: "SGT", name: "Secretaria General Técnica",
                 updated_by: "dev_seed")
  to3 = OrganizationType.create!(acronym: "AG", name: "Áreas de Gobierno",
                 updated_by: "dev_seed")
  to4 = OrganizationType.create!(acronym: "OOAA", name: "Organismos Autónomos",
                 updated_by: "dev_seed")


puts "Creando periodos"

  pdo1 = Period.create!(organization_type_id: to1.id, description: "Actividades de 2015",
                        started_at: "01/01/2015", ended_at: "31/12/2015",
                        opened_at: "01/04/2016", closed_at: "30/05/2016",
                        updated_by: "dev_seed")

  pdo2 = Period.create!(organization_type_id: to.id, description: "Actividades de 2015",
                        started_at: "01/01/2015", ended_at: "31/12/2015",
                        opened_at: "01/04/2016", closed_at: "30/05/2016",
                        updated_by: "dev_seed")

puts "Creando procesos"
  (1..5).each do |i|
    item =  Item.reorder("RANDOM()").first
    mp = MainProcess.create!(period_id: pdo2.id, item_id: item.id, order: i, updated_by: "dev_seed")
    (1..4).each do |i|
      item =  Item.reorder("RANDOM()").first
      sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: i, item_id: item.id, order: i, updated_by: "dev_seed")
      (1..4).each do |i|
        item =  Item.reorder("RANDOM()").first
        tk = Task.create!(sub_process_id: sp.id, item_id: item.id, order: i, updated_by: "dev_seed")
      end
    end
  end
