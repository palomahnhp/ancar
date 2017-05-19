namespace :process_name do

  desc "Plantilla/Puestos"
  task :assigned_employees => :environment do
    puts 'Denominación de Staff según organización'

    puts ProcessName.find_or_create_by(organization_type_id: 2, model: "assigned_employees", name: "Positions", updated_by: 'initialize').model
    puts ProcessName.find_or_create_by(organization_type_id: 1, model: "assigned_employees", name: "Staff", updated_by: 'initialize').model

    puts 'Termina el proceso'
  end
end

