namespace :sgt_new_items do

  desc "Crear nuevos items"
  task create_items: :environment do
    item_data.each do |item|
      puts Item.create!(item_type: item[1], description: item[0], updated_by: 'admin')
    end

  end

  private

  def item_data
    {
        'Número de accesos controlados en los edificios cuya gestión está encomendada a esa Secretaría General Técnica a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de contratos de arrendamiento de edificios gestionados por la Secretaría General Técnica a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de dependencias del Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de edificios adscritos a Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de empleados con crédito horario a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de empleados del Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de empleados que ocupan puestos del Área de Gobierno a fecha 31 de diciembre del año, excepto los gestionados por centros directivos con competencias específicas (Policía Municipal, Bomberos, Emergencias y Agentes de Movilidad).'	=> 'metric',
        'Número de empleados que ocupan puestos del Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de empleados que ocupan puestos del Área de Gobierno a fecha 31 de diciembre del año, excepto los gestionados por centros directivos con competencias específicas (Policía Municipal, Bomberos y Emergencias)'	=> 'metric',
        'Número de  libros y revistas existentes en el fondo bibliográfico a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de plazas de estacionamiento del  Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número total de equipos de telefonía del Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número total de equipos informáticos  del Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número total de puestos de trabajo en RPT adscritos al Área de Gobierno a fecha 31 de diciembre del año.'	=> 'metric',
        'Número de registros realizados por la Secretaría General Técnica en el Libro de Registros de Decretos y Resoluciones durante el año' => 'metric',
        'Importe total de los contratos de mantenimiento y reparación de mobiliario y equipos multifunción en el año' => 'metric',
        'Número de convenios registrados durante el año.' => 'metric'
    }
  end

end