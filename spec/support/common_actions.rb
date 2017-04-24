module CommonActions

  def login_as_authenticated_user(user)
    login, user_key, date = user.login, "31415926", Time.now.strftime("%Y%m%d%H%M%S")
    allow_any_instance_of(UwebAuthenticator).to receive(:auth).and_return({login: login, user_key: user_key, date: date}.with_indifferent_access)
    visit sign_in_path(login: login, clave_usuario: user_key, fecha_conexion: date)
  end

  def login_as_supervisor
    supervisor = create(:validator)
    login_as(supervisor.user)
    visit management_sign_in_path
  end

  def user_with_global_scope
    click_link("Procesos y subprocesos", :match => :first)

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

end
