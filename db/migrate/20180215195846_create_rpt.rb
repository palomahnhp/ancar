class CreateRpt < ActiveRecord::Migration
  def change
    create_table :rpts do |t|
      t.integer :year
      t.references :organization
      t.references :unit
      t.string  :den_unidad
      t.date    :fecha_baja
      t.date    :fecha_actualiz
      t.integer :id_puesto
      t.string  :den_puesto
      t.string  :grupo_personal
      t.string  :grupo_personal_txt
      t.string  :area_personal
      t.string  :area_personal_txt
      t.string  :grtit_per
      t.string  :grtit_pto
      t.string  :situacion
      t.string  :modalidad
      t.string  :nombre
      t.string  :apellido1
      t.string  :apellido2
      t.string  :sociedad
      t.string  :division
      t.string  :status_pto_txt
      t.string  :editable_Z01
      t.string  :ocupada
    end
  end
end
