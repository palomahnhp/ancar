require 'rails_helper'

feature 'Periods Maintenance' do

  describe 'Index of periods' do
    it 'has correct buttons for opened period ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      expect(page).to have_content I18n.t('supervisor.periods.index.entry_not_open_yet')
      expect(page).to have_link 'ver procesos'
      expect(page).to have_link 'editar'
      expect(page).to have_link 'eliminar'
    end

    it "has correct buttons for closed period " do
      period = Period.first

      period.opened_at = Time.now - 2.day
      period.closed_at = Time.now - 1.day
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      expect(page).to have_content I18n.t('supervisor.periods.index.entry_closed')
      expect(page).to have_link 'ver procesos'
      expect(page).not_to have_link 'editar'
      expect(page).not_to have_link 'eliminar'

    end

    it "has correct buttons for not open yet period " do
      period = Period.first

      period.opened_at = Time.now + 1.months
      period.closed_at = Time.now + 2.months
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      expect(page).to have_content I18n.t('supervisor.periods.index.entry_not_open_yet')
      expect(page).to have_link 'ver procesos'
      expect(page).to have_link 'editar'
      expect(page).to have_link 'eliminar'

    end

  end

  describe 'Create a new Period' do

    it "create a new empty period" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'Crear un periodo'

      find('#period_organization_type_id').find(:xpath, 'option[2]').select_option
      fill_in 'period_description', with: 'Nuevo Periodo de Distritos'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at', with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at', with: (Time.now).beginning_of_month
      fill_in 'closed_at', with: (Time.now).end_of_month

      click_button 'Crear'

      expect(page).to have_content 'Se ha creado el periodo correctamente. Debera incluir los procesos e indicadores desde la opción "Configurar indicadores".'

      within("#period_2") do
        click_link "ver procesos"
      end

      expect(page).to have_content 'No hay procesos para este periodo'
    end

    it 'copy another period elements' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'Crear un periodo'

      page.select 'Secretarías Generales Técnicas', :from => 'period_organization_type_id'

      fill_in 'period_description', with: 'Nuevo Periodo de Distritos 1999'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at', with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at', with: (Time.now - 1.days).beginning_of_month
      fill_in 'closed_at', with: (Time.now + 15.days).end_of_month

      page.select "Periodo de análisis de datos", :from => 'period_id'

      click_button 'Crear'

      expect(page).to have_content 'Se ha creado el periodo correctamente con los procesos e indicatores del periodo seleccionado.'

    end

    it 'copy main_processes' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      click_link 'Configurar Periodos'
      click_link 'Crear un periodo'

      page.select 'Secretarías Generales Técnicas', :from => 'period_organization_type_id'

      fill_in 'period_description', with: 'Nuevo Periodo de Distritos 1999'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at', with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at', with: (Time.now - 1.days).beginning_of_month
      fill_in 'closed_at', with: (Time.now + 15.days).end_of_month

      page.select "Periodo de análisis de datos", :from => 'period_id'

      click_button 'Crear'

      within("#period_2") do
        click_link "ver procesos"
      end
      save_and_open_page
      expect(page).to have_selector('tr', count: 3)
      expect(page).to have_content 'GENÉRICOS'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '2. AUTORIZACIONES Y CONCESIONES'
      expect(page).to have_link('Editar', count: 2)
      expect(page).to have_link('Eliminar', count: 2)

    end

    it 'copy sub_processes' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      click_link 'Configurar Periodos'
      click_link 'Crear un periodo'

      page.select 'Secretarías Generales Técnicas', :from => 'period_organization_type_id'

      fill_in 'period_description', with: 'Nuevo Periodo de Distritos 1999'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at', with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at', with: (Time.now - 1.days).beginning_of_month
      fill_in 'closed_at', with: (Time.now + 15.days).end_of_month

      page.select "Periodo de análisis de datos", :from => 'period_id'

      click_button 'Crear'

      within("#period_2") do
        click_link "ver procesos"
      end

      within("#main_process_3") do
        click_link "Ver subprocesos"
      end
save_and_open_page
      expect(page).to have_selector('tr', count: 3)
      expect(page).to have_content 'DEPARTAMENTO DE SERVICIOS JURIDICOS'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content '2. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'
      expect(page).to have_link('Editar', count: 2)
      expect(page).to have_link('Eliminar', count: 2)
    end

    it 'copy indicators' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      click_link 'Configurar Periodos'
      click_link 'Crear un periodo'

      page.select 'Secretarías Generales Técnicas', :from => 'period_organization_type_id'

      fill_in 'period_description', with: 'Nuevo Periodo de Distritos 1999'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at', with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at', with: (Time.now - 1.days).beginning_of_month
      fill_in 'closed_at', with: (Time.now + 15.days).end_of_month

      page.select "Periodo de análisis de datos", :from => 'period_id'

      click_button 'Crear'

      within("#period_2") do
        click_link "ver procesos"
      end

      within("#main_process_3") do
        click_link "Ver subprocesos"
      end

      click_link("Ver indicadores", :match => :first)
      expect(page).to have_selector('tr', count: 5)
      expect(page).to have_content 'Organización: Secretarías Generales Técnicas'
      expect(page).to have_content 'Periodo: Nuevo Periodo de Distritos 1999'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'Indicadores'
      expect(page).to have_content 'Métrica'
      expect(page).to have_content 'Fuente'
      expect(page).to have_content 'Totalizadores'
      expect(page).to have_link 'Incluir métrica'
      expect(page).to have_content '1.1.1. Contratos Menores'
      expect(page).to have_content 'Nº de Contratos recibidos'
      expect(page).to have_content 'Nº de Contratos tramitados'
      expect(page).to have_content('SIGSA', count: 2)
      expect(page).to have_link('Editar', count: 3)
      expect(page).to have_link('Eliminar', count: 3)

      within('tr#indicator_metric_5') do
        within('td#summary_type_1') do
          expect(page).to have_content '-'
        end
        within('td#summary_type_2') do
          expect(page).to have_content 'S'
        end
        within('td#summary_type_3') do
          expect(page).to have_content '-'
        end
      end
    end
  end
end
