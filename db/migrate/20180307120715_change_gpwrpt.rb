class ChangeGpwrpt < ActiveRecord::Migration
  def change
    drop_table :rpts

    create_table :rpts do |t|
      t.integer  :year
      t.string   :den_area
      t.string   :sapid_area
      t.string   :sapid_unidad
      t.string   :den_unidad
      t.string   :den_short_unidad

      t.references :organization
      t.references :unit

#     position
      t.integer :id_puesto
      t.string  :den_puesto
      t.string  :sociedad
      t.string  :division
      t.string  :den_tipo_puesto
      t.string  :nivel_pto
      t.string  :grtit_pto
      t.string  :forma_acceso
      t.string  :grupo_personal
      t.string  :grupo_personal_txt
      t.string  :area_personal
      t.string  :area_personal_txt
      t.string  :grtit_pto
      t.string  :forma_acceso_pto
      t.string  :status_pto_txt
      t.string  :editable_Z01
      t.string  :ficticio_Z02
      t.string  :ocupada
      t.string  :dotado
      t.string  :observaciones_txt_pto

      # Persona
      t.string  :nombre
      t.string  :apellido1
      t.string  :apellido2
      t.string  :perid
      t.string  :sexo
      t.string  :den_categoria_per
      t.string  :grtit_per
      t.string  :grupo_personal
      t.string  :grupo_personal_txt
      t.string  :area_personal
      t.string  :area_personal_txt
      t.string  :situacion
      t.string  :modalidad
      t.string  :relacion_laboral
      t.string  :poblacion
      t.string  :fecha_nacimiento
      t.string  :fecha_antiguedad
      t.string  :fecha_trienios
      t.string  :fecha_baja
      t.string  :fecha_actualiz

      # condiciones consulta
      t.string  :fecha_baja_desde
      t.string  :fecha_baja_hasta
      t.string  :fecha_actualizado_hasta

      t.timestamp
    end

  end
end
