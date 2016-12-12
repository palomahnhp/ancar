require 'rails_helper'
include CommonActions

feature "Entry Indicators" do
  background do
    create_organizations
    period = create_period
    create_process(period)
  end

  describe "datos de unidad " do
    it 'primera unidad de la organización' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Indicadores", :match => :first)
      click_link("Periodo", :match => :first)
      within('div#unit') do
        expect(page).to have_content "DEPARTAMENTO DE SERVICIOS JURIDICOS"
      end
    end

    it 'cambia de unidad' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Indicadores", :match => :first)
      click_link("Periodo", :match => :first)
      click_link "SECRETARIA DE DISTRITO"
      within('div#unit') do
        expect(page).to have_content "SECRETARIA DE DISTRITO"
      end
      save_and_open_page
    end

    it 'muestra efectivos de unidad' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:unit_user, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      add_staff("Unit", unit.id, unit.id, 1, 2, 1, 0)

      click_link("Indicadores", :match => :first)

      save_and_open_page
      debugger
      within("#organization_#{organization.id}") do
        click_link "Periodo"
      end

    end

    it 'procesos' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Indicadores", :match => :first)

      within('table#staff_Unit') do
        click_link("Periodo", :match => :first)
      end
      expect(page).to have_content "DEPARTAMENTO DE SERVICIOS JURIDICOS"
    end

    it 'sub_procesos' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Indicadores", :match => :first)
      click_link("Periodo", :match => :first)

      expect(page).to have_content "DEPARTAMENTO DE SERVICIOS JURIDICOS"
    end

    it 'indicadores' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Indicadores", :match => :first)
      click_link("Periodo", :match => :first)

      expect(page).to have_content "DEPARTAMENTO DE SERVICIOS JURIDICOS"
    end

  end

  describe 'formulario de actualización' do
      it 'muestra todos los campos para actualización en vista edit'
      it 'muestra los checks de agrupación correctamente marcados'
      it 'muestra todos los campos vacios en vista new'
      it 'muestra el botón para actualizar en edit'
      it 'muestra el botón para actualizar en new'
      it 'propone contenido en descripcion'
      it 'crea nueva descripcion'
      it 'propone contenido en métricas'
      it 'crea nueva métrica'
      it 'propone contenido en fuentes'
      it 'crea nueva fuente'
  end

end
