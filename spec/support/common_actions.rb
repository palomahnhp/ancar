module CommonActions

  def login_as_authenticated_user(user)
    login, user_key, date = user.login, "31415926", Time.now.strftime("%Y%m%d%H%M%S")
    allow_any_instance_of(UwebAuthenticator).to receive(:auth).and_return({login: login, user_key: user_key, date: date}.with_indifferent_access)
    visit sign_in_path(login: login, clave_usuario: user_key, fecha_conexion: date)
  end

  def login_as_manager
    manager = create(:manager)
    login_as(manager.user)
    visit management_sign_in_path
  end

  def user_with_global_scope
    click_link("Indicadores", :match => :first)

    expect(page).to have_content "Hoja de identificación de procesos"
    expect(page).to have_content "Selección de unidad a tratar"
    expect(page).to have_content "Distritos"
    expect(page).to have_content "Secretarías Generales Técnicas"
    expect(page).to have_content "Selección de unidad a tratar"

    click_link "Distritos"

    expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA"
    expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS"
    expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE CENTRO"
    expect(page).to have_content "Periodo"
  end

  def error_message(resource_model=nil)
    resource_model ||= "(.*)"
    /\d errors? prevented this #{resource_model} from being saved:/
  end

  def add_staff(staff_of_type, staff_of_id, unit_id, period, grupoA1, grupoA2, grupoC1, grupoC2 )
    group = OfficialGroup.find_by_name("A1")
    AssignedEmployee.create!(staff_of_type: staff_of_type, staff_of_id: staff_of_id,
          official_group_id: group.id, unit_id: unit_id, quantity: grupoA1, period_id: period.id )
    group = OfficialGroup.find_by_name("A2")
    AssignedEmployee.create!(staff_of_type: staff_of_type, staff_of_id: staff_of_id,
          official_group_id: group.id, unit_id: unit_id, quantity: grupoA2, period_id: period.id )
    group = OfficialGroup.find_by_name("C1")
    AssignedEmployee.create!(staff_of_type: staff_of_type, staff_of_id: staff_of_id,
          official_group_id: group.id, unit_id: unit_id, quantity: grupoC1, period_id: period.id )
    group = OfficialGroup.find_by_name("C2")
    AssignedEmployee.create!(staff_of_type: staff_of_type, staff_of_id: staff_of_id,
          official_group_id: group.id, unit_id: unit_id, quantity: grupoC2, period_id: period.id )
#    expect(find('.top-bar')).to have_content 'My account'
  end

  def select_date(values, selector)
    selector = selector[:from]
    day, month, year = values.split("-")
    select day,   from: "#{selector}_3i"
    select month, from: "#{selector}_2i"
    select year,  from: "#{selector}_1i"
  end

  def create_period
    organization_type = OrganizationType.first
    create(:period, organization_type_id: organization_type.id)
  end

  def create_organizations
    organization_type = OrganizationType.first
    organization_data = [
       ["JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA","10000003", "1"],
       ["JUNTA MUNICIPAL DEL DISTRITO DE CENTRO","10000003", "3"],
       ["JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS","10000022", "2"] ]

    organization_data.each do |data|
      organization = Organization.create!(organization_type_id: organization_type.id,
                           description: data[0],
                           sap_id: data[1],
                           order: data[2] )
      create_units(organization, organization_type.id)
     end
  end

  def create_units(organization, organization_type_id)
    sap_id = 10200100
    UnitType.where(organization_type_id: organization_type_id).order(:id).each_with_index do |unit_type, index|
      Unit.create!(unit_type_id: unit_type.id, organization_id: organization.id,
                   description_sap: unit_type.description, sap_id: sap_id + index, order: index + 1)
    end
  end

  def create_process(period)
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

    metric_item = Item.create!(item_type: "metric", description: "Nº de Contratos tramitados")
    metric = Metric.create!(item_id: metric_item.id)
    indicator_metric = IndicatorMetric.create!(indicator_id: indicator.id, metric_id: metric.id)

    source_item = Item.create!(item_type: "source", description: "SIGSA")
    source = Source.create!(item_id: source_item.id)
    indicator_source = IndicatorSource.create!(indicator_id: indicator.id, source_id: source.id)

    mp2 = MainProcess.create!(period_id: period.id, item_id: Item.create!(item_type: "main_process",
                                         description: "AUTORIZACIONES Y CONCESIONES").id,
                          order: "2")
  end

  def create_entry_indicators

  end
end
