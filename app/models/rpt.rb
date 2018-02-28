class Rpt < ActiveRecord::Base
  belongs_to :organization
  belongs_to :unit

  validates_presence_of :year, :organization_id, :id_puesto

  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :by_unit_sap,     ->(unit) { where( sapid_unidad: unit ) }
  scope :by_year,         ->(year) { where( year: year ) }
  scope :vacant,          -> { where(ocupada: 'VC') }
  scope :occupied,        -> { where(ocupada: 'OC') }
  scope :a1,              -> { where(grtit_per: 'A1') }
  scope :a2,              -> { where(grtit_per: 'A2') }
  scope :c1,              -> { where(grtit_per: 'C1') }
  scope :c2,              -> { where(grtit_per: 'C2') }
  scope :e,               -> { where(grtit_per: 'E') }
  scope :nogrtit,         -> { where(grtit_per:   'X') }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |rpt|
        csv << rpt.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(year, file='')
    if file.present?
      self.import_from_xls(file)
    else
      self.import_from_rptdb(year)
    end
  end

  def self.import_from_rptdb(year)
    Gpwrpt.connection
    Organization.all.each do |organization|
      sql_import_rpt_sentence(year, organiztion)
      rpt_data = Gpwrpt.find_by_sql(sql_import_rpt_sentence(year, organization))
      update_rpt_data(rpt_data)
    end

  end

  def self.import_from_xls(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      rpt = find_by(year: row["year"], sapid_organizacion: row["sapid_organizacion"],
                    sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"]) || new
      rpt.attributes   = row.to_hash
      rpt.organization = Organization.find_by(sap_id: row["sapid_organizacion"])
      rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
      Rails.logger.info { "No se actualiza el registro " + i.to_s + row["den_organizacion"] } unless rpt.save
    end
    true
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  private

  def sql_import_rpt_sentence(year, organization)
    fecha_baja = year.to_s + '1231'
    fecha_actualiz = (year + 1).to_s + '0101'

   "WITH PADRES(ID_UNIDAD, ID_UNIDAD_PADRE)
    AS
    (
      SELECT unidad.ID_UNIDAD, unidad.ID_UNIDAD_PADRE
        FROM DIRECTORIO.CEMI.GPWA200 unidad
      -- Organización a procesar
        WHERE unidad.ID_UNIDAD = #{organization.id})

      UNION ALL

      SELECT HIJA.ID_UNIDAD, HIJA.ID_UNIDAD_PADRE
      FROM DIRECTORIO.GPW.ORGANICO_DIR HIJA, PADRES PADRE
      WHERE HIJA.ID_UNIDAD_PADRE = PADRE.ID_UNIDAD
    )
    -- Datos de rpt de personal de las unidades seleccionadas antes
    -- Cambiar idsap_organizacion a la organización de la que se están tratando las unidades
    select #{year} as year, #{organization.description} as den_organizacion,
           #{organization.id} as sapid_organizacion,
           rpt.id_unidad as sapid_unidad, den_unidad,
           fecha_baja, fecha_actualiz, id_puesto, den_puesto,
           grupo_personal, grupo_personal_txt, area_personal, area_personal_txt, grtit_per, grtit_pto,
           situacion, modalidad,
           nombre, apellido1, apellido2,
           sociedad, division,
           status_pto_txt, editable_Z01, ocupada
    from GPWRPT.gpw.rpt001 as rpt
    join directorio.gpw.gpwa200 as directorio on rpt.id_unidad = directorio.id_unidad
    where sociedad = 'MDRD' and
        -- Las bajas anteriores a 31/12 no las tiene en cuenta
        (fecha_baja > '#{fecha_baja}'  OR fecha_baja = '99991231')  and
        fecha_actualiz < '#{fecha_actualiz}'  and
        rpt.id_unidad in (SELECT  u.ID_UNIDAD
    FROM  DIRECTORIO.GPW.ORGANICO_DIR u
    WHERE u.ID_UNIDAD IN (SELECT DISTINCT ID_UNIDAD FROM PADRES)
    )
    order by grtit_per, den_unidad
    ;"

  end

  def update_rpt_data (data)
    data.each do |datum|
      p datum
    end
  end

end