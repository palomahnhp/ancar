require 'rails_helper'

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
    end

    it 'muestra efectivos de unidad' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:unit_user, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first
      add_staff("Unit", unit.id, unit.id, period, 1, 0.5, 1, 0.5)
      click_link("Indicadores", :match => :first)

      within("#organization_#{organization.id}") do
        click_link "Periodo"
      end

      within("table#staff_Unit") do
        expect(page).to have_content("1.0", count: 2)
        expect(page).to have_content("0.5", count: 2)
      end
    end
  end

  describe "Procesos y Subprocesos" do

    it 'muestra los procesos' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:unit_user, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Indicadores", :match => :first)

      within("#organization_#{organization.id}") do
        click_link "Periodo"
      end

      expect(page).to have_content "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
    end

    it 'muestra los sub_procesos' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:unit_user, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Indicadores", :match => :first)

      within("#organization_#{organization.id}") do
        click_link "Periodo"
      end

      expect(page).to have_content "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO"
      expect(page).to have_content "TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO"

    end

    it 'muestra los  indicadores' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Indicadores", :match => :first)

      click_link("Periodo", :match => :first)
      expect(page).to have_content "Contratos Menores"
      expect(page).to have_content("SIGSA", count: 2)
      expect(page).to have_content "Nº de Contratos recibidos"
      expect(page).to have_content "Nº de Contratos tramitados"

    end

    it 'muestra efectivos de indicador' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:unit_user, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first
      indicators = period.main_processes.first.sub_processes.where(unit_type_id: unit.unit_type_id).first.indicators
      indicators.each do |indicator|
        add_staff("Indicator", indicator.id, unit.id, period, rand(9), rand(99), rand(99), rand(99))
      end

      click_link("Indicadores", :match => :first)

      within("#organization_#{organization.id}") do
        click_link "Periodo"
      end

      pending('por finalizar desarrollo')

      expect(page).to have_content "efectivos"
    end

    it 'muestra efectivos de subprocesos' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:unit_user, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      indicators = period.main_processes.first.sub_processes.where(unit_type_id: unit.unit_type_id).first.indicators
      indicators.each do |indicator|
        add_staff("Indicator", indicator.id, unit.id, period, rand(9), rand(99), rand(99), rand(99))
      end
      click_link("Indicadores", :match => :first)

      within("#organization_#{organization.id}") do
        click_link "Periodo"
      end

      pending('por finalizar desarrollo')
      expect(page).to have_content "efectivos"
    end

  end

  describe 'formulario de actualización' do

      it "es editable si usuario con permiso y periodo abierto: aparecen botones y campos imput "
      it "no es editable si usuario sin permiso y periodo abierto no botones y campos input"
      it 'no es editable si periodo cerrado'
      it 'no es editable si tiene VºBº del validador'
  end


end
