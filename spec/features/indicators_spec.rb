require 'rails_helper'

feature 'Indicators Maintenance' do
  background do
    create_organizations
    period = create_period
    create_process(period)
  end

  describe 'index of indicators' do
    it 'listado de indicadores' do
      manager = create(:manager_global)
      login_as_authenticated_user(manager)

      visit manager_root_path

      click_link 'Configurar Periodos'
      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end
      click_link("Ver indicadores", :match => :first)

      expect(page).to have_selector('tr', count: 5)
      expect(page).to have_content 'Organización: Distritos'
      expect(page).to have_content 'Periodo: Periodo de análisis de datos'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'Indicadores'
      expect(page).to have_content 'Métrica'
      expect(page).to have_content 'Fuente'
      expect(page).to have_content 'Totalizadores'

      expect(page).to have_content '1.1.1. Contratos Menores'
      expect(page).to have_content 'Nº de Contratos recibidos'
      expect(page).to have_content 'Nº de Contratos tramitados'
      expect(page).to have_content('SIGSA', count: 2)

      within('tr#indicator_metric_1') do
        expect(page).to have_selector('td#E', count: 1)
        expect(page).to have_selector('td#U', count: 1)
        expect(page).to have_selector('td#-', count: 1)
      end

      within('tr#indicator_metric_2') do
        expect(page).to have_selector('td#S', count: 1)
        expect(page).to have_selector('td#-', count: 2)
      end
    end


    it 'has correct buttons for opened period ' do

      period = Period.first
      period.opened_at = Time.now - 2.months
      period.closed_at = Time.now + 1.months
      period.save

      manager = create(:manager_global)
      login_as_authenticated_user(manager)

      visit manager_root_path

      click_link 'Configurar Periodos'
      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end

      expect(page).to have_link('Editar', count: 2)
      expect(page).to have_link('Eliminar', count: 2)
    end

    it "has correct buttons for closed period " do
      period = Period.first

      period.opened_at = Time.now - 2.months
      period.closed_at = Time.now - 1.months
      period.save

      manager = create(:manager_global)
      login_as_authenticated_user(manager)

      visit manager_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end

      expect(page).not_to have_link 'Editar'
      expect(page).not_to have_link 'Eliminar'

    end

    it "has correct buttons for not open yet period " do
      period = Period.first

      period.opened_at = Time.now + 1.months
      period.closed_at = Time.now + 2.months
      period.save

      manager = create(:manager_global)
      login_as_authenticated_user(manager)

      visit manager_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end

      expect(page).to have_link 'Editar'
      expect(page).to have_link 'Eliminar'
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
