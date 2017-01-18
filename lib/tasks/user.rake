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
          rol = u.add_role :manager, Organization
          puts "       =>#{rol.inspect}"
        when 3
          rol = u.add_role :admin
          puts "       =>#{rol.inspect}"
          rol = u.add_role :manager
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

