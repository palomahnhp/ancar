require 'rails_helper'

feature 'Periods Maintenance' do
  describe 'Index of periods' do
    it 'has correct buttons for opened period ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)
      period_not_yet_opened

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_1") do
        expect(page).to have_content I18n.t('supervisor.periods.index.entry_not_open_yet')
        expect(page).to have_link 'ver procesos'
        expect(page).to have_link 'editar'
        expect(page).to have_link 'eliminar'
      end
    end

    it "has correct buttons for closed period " do
      period_closed

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_1") do
        expect(page).to have_content I18n.t('supervisor.periods.index.entry_closed')
        expect(page).to have_link 'ver procesos'
        expect(page).not_to have_link 'editar'
        expect(page).not_to have_link 'eliminar'
      end

    end

    it "has correct buttons for not open yet period " do
      period_not_yet_opened

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_1") do
        expect(page).to have_content I18n.t('supervisor.periods.index.entry_not_open_yet')
        expect(page).to have_link 'ver procesos'
        expect(page).to have_link 'editar'
        expect(page).to have_link 'eliminar'
      end
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

      within("#period_3") do
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

      page.select "Periodo de análisis de datos Distritos", :from => 'period_id'

      click_button 'Crear'

      expect(page).to have_content 'Se ha creado el periodo correctamente con los procesos e indicatores del periodo seleccionado.'

    end

    it 'copy main_processes' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      click_link 'Configurar Periodos'
      click_link 'Crear un periodo'

      page.select 'Distritos', :from => 'period_organization_type_id'

      fill_in 'period_description', with: 'Nuevo Periodo de Distritos 1999'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at',   with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at',  with: (Time.now + 1.month).beginning_of_month
      fill_in 'closed_at',  with: (Time.now + 1.month).end_of_month

      page.select "Periodo de análisis de datos Distritos", :from => 'period_id'

      click_button 'Crear'

      within("#period_3") do
        click_link "ver procesos"
      end

      expect(page).to have_selector('tr', count: 2)
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

      fill_in 'period_description', with: 'Nuevo Periodo de análisis de datos SGT'
      fill_in 'started_at', with: (Time.now - 1.year).beginning_of_year
      fill_in 'ended_at', with: (Time.now - 1.year).end_of_year
      fill_in 'opened_at', with: (Time.now + 1.month).beginning_of_month
      fill_in 'closed_at', with: (Time.now + 1.month).end_of_month

      page.select "Periodo de análisis de datos SGT 2", :from => 'period_id'

      click_button 'Crear'

      within("#period_3") do
        click_link "ver procesos"
      end

      within("#main_process_6") do
        click_link "Ver subprocesos"
      end

      expect(page).to have_content 'Nuevo Periodo de análisis de datos SGT'
      expect(page).to have_link('Editar', count: 2)
      expect(page).to have_link('Eliminar', count: 2)
    end
  end
end
