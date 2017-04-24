namespace :user do

  desc "Carga inicial de Coordinadores de Distrito"
  task coordinadores_distritos: :environment do
    puts "Creando coordinadores distrito"
    file = "Coordinadores distrito_2016.xls"
    libro = Spreadsheet.open file
    hoja = libro.worksheet 0
    (hoja.rows).each  do |f|
      puts f.idx
      next if f.idx == 0
      create_user(f)
    end
  end

  desc "Carga inicial Usuarios SGT"
  task carga_SGT: :environment do
    puts "Creando usuarios SGT"
    usuarios_SGT_2016.each  do |f|
      puts "#{f[0]} - #{f[1]}"
      login = f[0]
      rol_organization = f[1].split("/")
      user = User.find_by(login: login)
      if user.nil?
        user = User.create(login: login, name: login[0], surname: login[1], second_surname: login[2], uweb_id: 1, pernr: 1 )
      end
      puts "#{user.id} #{user.login} #{user.errors.messages}"
      organization_type = OrganizationType.find_by_acronym('SGT')
      puts rol_organization[1]
      organizacion = Organization.find_by_sap_id(rol_organization[1])

      case rol_organization[0]
        when 'Admin'
          rol = user.add_role :admin
        when 'Supervisor'
          rol = user.add_role :validator, organization_type
        when 'Validador'
          rol = user.add_role :validator, organizacion
        when 'Usuario'
          rol = user.add_role :unit_user, organizacion
      end
      puts "       =>#{rol.inspect}"
    end
  end

  desc 'Añadir roles rolify a usuarios preexistentes'
  task add_roles: :environment do

    User.all.each do |u|
      puts "#{u.login} => #{u.role}"
      case u.role
        when nil
          u.user_organizations.each do |uo|
            rol = u.add_role :unit_user, uo.organization
            puts "       =>#{rol.inspect}"
          end
        when 1
          u.user_organizations.each do |uo|
            rol = u.add_role :validator, uo.organization
            puts "       =>#{rol.inspect}"
          end
        when 2
          rol = u.add_role :validator, Organization
          puts "       =>#{rol.inspect}"
        when 3
          rol = u.add_role :admin
          puts "       =>#{rol.inspect}"
          rol = u.add_role :validator
          puts "       =>#{rol.inspect}"
      end
    end
  end

  desc 'Añadir id de unidad'
  task change_user_unit: :environment do
    User.where("unit_description != ? ", '' ).each do |u|
       u.organization =  Organization.find_by(description: u.organization_description)
    end
  end

end

private

  def create_user(f)
    login = f[0]
    pernr = f[1]
    name = f[2]
    surname = f[3]
    second_surname = f[4]
    type_document = f[5]
    document = f[6]
    email = f[7]
    official_position = f[8]
    unit_id = f[9]
    id_organization = f[10]
    organization_desc = f[11]
    user = User.create(login: login, name: name, surname: surname, second_surname: second_surname,
                 official_position: official_position, unit: organization_desc, email: email,
                  pernr: pernr, uweb_id: pernr, )
    org = Organization.find_by_sap_id(id_organization)
    uo = UserOrganization.find_or_create_by!(user_id: user.id, organization_id: org.id)
    puts "   #{login} - #{organization_desc} "
  end

  def usuarios_SGT_2016
    {

    'JAM066'	=> 'Supervisor',
    'JPR029'  => 'Supervisor',
    'MJG015'	=> 'Supervisor',
    'PAC007'	=> 'Admin',
    'PHN001'	=> 'Admin',
    'LTM004'	=> 'Admin',
    'ECQ001'	=> 'Usuario/10005748 ',
    'ICM003'	=> 'Usuario/10005748',
    'SMF001'	=> 'Validador/10005748',
    'AMB030'	=> 'Usuario/10005782',
    'JVG022'  => 'Validador/10005782',
    'BEY001'	=> 'Usuario/10005803',
    'CSB009'	=> 'Usuario/10005803',
    'EMM027'	=> 'Validador/10005803',
    'EFD001'	=> 'Validador/10005875',
    'MSN001'	=> 'Usuario/10005875',
    'JCC009'	=> 'Usuario/10005924',
    'MVZ001'	=> 'Validador/10005924',
    'JMA078'	=> 'Validador/10005965',
    'MHV003'	=> 'Usuario/10005965',
    'MMV015'	=> 'Usuario/10005965',
    'IGI001'	=> 'Validador/10006068',
    'MNG018'	=> 'Usuario/10006068',
    'IRG002'	=> 'Validador/10213100',
    'VRG002'	=> 'Usuario/10213100'
    }
  end