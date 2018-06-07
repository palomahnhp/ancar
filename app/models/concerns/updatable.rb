module Updatable
  extend ActiveSupport::Concern

  def uweb_update
    uweb_data = UwebApi.new(login: self.login).get_user
    if uweb_data.present? && login == uweb_data[:login]
      self.uweb_id  = uweb_data[:uweb_id]
      self.phone    = uweb_data[:phone]
      self.email    = uweb_data[:email]
      self.pernr    = uweb_data[:pernr]
      self.uweb_active = uweb_data[:active]
      if self.uweb_active # se prefieren los datos de directorio que se usaron cuando estaba activo
        # Datos básicos para personal externo, que en el caso de empleados se sobreescribiran con datos de Directorio
        self.name           = uweb_data[:name]
        self.surname        = uweb_data[:surname]
        self.second_surname = uweb_data[:second_surname]
      end
      self.sap_den_unit      = uweb_data[:unit]
      self.official_position = uweb_data[:official_position]
      true
    else
      false
    end
  end

  def uweb_on!(uweb_id)
    if UwebUpdateApi.new(uweb_id).insert_profile(self)
      self.uweb_auth_at = Time.now
      self.save
      return true
    end
    false
  end

  def uweb_off!(uweb_id)
    if UwebUpdateApi.new(uweb_id).remove_profile(self)
      self.uweb_auth_at = nil
      self.save
      return true
    end
    false
  end

  def uweb?
    # tiene  acceso?
  end

  def directory_update
    data  = DirectoryApi.new.employees_data(pernr: self.pernr)

    user_data = data['EMPLEADOS_ACTIVOS']['EMPLEADO'] if data['EMPLEADOS_ACTIVOS'].present?
    if user_data.present?
      self.document_number    = user_data['NIF']
      self.name               = fix_encoding(user_data['NOMBRE'])
      self.surname            = fix_encoding(user_data['APELLIDO1'])
      self.second_surname     = fix_encoding(user_data['APELLIDO2'])
      self.document_number    = user_data['NIF']
      self.official_position  = fix_encoding(user_data['DENOMINACION_PUESTO'])
      self.sap_den_unit       = fix_encoding(user_data['DEN_UNIDAD_FUNCIONAL'])
      self.sap_id_unit        = user_data['ID_UNIDAD_FUNCIONAL']

      data  = DirectoryApi.new.get_unit_data(self.sap_id_unit)
      unit_data = data['UNIDAD_ORGANIZATIVA']
      if unit_data.present?
        self.assign_organization(unit_data)
#        self.sap_id_organization  = unit_data['AREA']
#        self.sap_den_organization = fix_encoding(unit_data['DENOM_AREA'])
      end
    else
      false
    end
  end

  def directory_update!
    if self.directory_update
      self.save
    else
      false
    end
  end

  def uweb_update!
    if self.uweb_update
      self.save
    else
      false
    end
  end
end