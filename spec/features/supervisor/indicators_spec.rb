require 'rails_helper'

feature 'Indicators Maintenance' do


  describe 'index of indicators' do

    it 'listado de indicadores' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

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
        within('td#summary_type_1') do
          expect(page).to have_content 'E'
        end
        within('td#summary_type_2') do
          expect(page).to have_content '-'
        end
        within('td#summary_type_3') do
          expect(page).to have_content 'U'
        end
      end

      within('tr#indicator_metric_2') do
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

    it 'has correct buttons for opened period ' do

      period = Period.first
      period.opened_at = Time.now - 1.days
      period.closed_at = Time.now + 1.months
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      click_link 'Configurar Periodos'
      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end
      within("#sub_process_1") do
        click_link "Ver indicadores"
      end

      expect(page).to have_link 'Incluir métrica'
      expect(page).to have_link('Editar', count: 3)
      expect(page).to have_link('Eliminar', count: 3)
    end

    it "has correct buttons for closed period " do
      period = Period.first

      period.opened_at = Time.now - 2.days
      period.closed_at = Time.now - 1.day
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end

      within("#sub_process_1") do
        click_link "Ver indicadores"
      end

      expect(page).not_to have_link 'Editar'
      expect(page).not_to have_link 'Eliminar'

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

      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end

      within("#sub_process_1") do
        click_link "Ver indicadores"
      end

      expect(page).to have_link 'Editar'
      expect(page).to have_link 'Eliminar'
    end
  end

  describe 'edit a indicator' do
    it 'show the correct fields' do
      period = Period.first
      period.opened_at = Time.now - 2.months
      period.closed_at = Time.now + 1.months
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      click_link 'Configurar Periodos'
      within("#period_1") do
        click_link "ver procesos"
      end
      within("#main_process_1") do
        click_link "Ver subprocesos"
      end
      within('#sub_process_1') do
        click_link 'Ver indicadores'
      end
      within('#indicator_1') do
        click_link 'Editar'
      end

      expect(page).to have_content 'Editar indicador'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content '1.1.1. Contratos Menores'

      description = page.find_field('indicator_item_id')
      expect(description.text).to eq 'Contratos Menores Expedientes urbanísticos'
      expect(description.tag_name).to eq('select')
      expect(description.value).to eq('15')

      button = page.find_button
      expect(button[:name]).to eq 'commit'
      expect(button.value).to eq 'Editar'
      expect(button.tag_name).to eq('input')

    end

    it 'changes indicator order an description with select options' do
      period = Period.first
      period.opened_at = Time.now - 2.months
      period.closed_at = Time.now + 1.months
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      click_link 'Configurar Periodos'
      within('#period_1') do
        click_link 'ver procesos'
      end
      within('#main_process_1') do
        click_link 'Ver subprocesos'
      end
      within('#sub_process_1') do
        click_link 'Ver indicadores'
      end
      within('#indicator_1') do
        click_link 'Editar'
      end

      select('Expedientes urbanísticos', :from => 'indicator_item_id')

      fill_in('indicator_order', :with => '99')
      click_button "Editar"

      expect(page.current_path).to  eq(supervisor_indicators_path)
      expect(page).to have_content 'Indicadores'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content '1.1.99. Expedientes urbanísticos'

    end
    it 'changes indicator writing descripcion' do
      period = Period.first
      period.opened_at = Time.now - 2.months
      period.closed_at = Time.now + 1.months
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      click_link 'Configurar Periodos'
      within('#period_1') do
        click_link 'ver procesos'
      end
      within('#main_process_1') do
        click_link 'Ver subprocesos'
      end
      within('#sub_process_1') do
        click_link 'Ver indicadores'
      end
      within('#indicator_1') do
        click_link 'Editar'
      end

      select('Expedientes urbanísticos', :from => 'indicator_item_id')

      find('#indicator_item_id').find(:xpath, 'option[2]').select_option
      fill_in 'item_description', with: 'Nueva descripción'

      click_button "Editar"

      expect(page.current_path).to  eq(supervisor_indicators_path)
      expect(page).to have_content 'Indicadores'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).not_to have_content '1.1.1. Expedientes urbanísticos'
      expect(page).to have_content '1.1. Nueva descripción'

    end

  end
  describe 'Delete a indicator' do

    it "delete a indicator and all references " do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      click_link 'Configurar Periodos'

      within('#period_1') do
        click_link 'ver procesos'
      end

      within('#main_process_1') do
        click_link 'Ver subprocesos'
      end

      within('#sub_process_1') do
        click_link 'Ver indicadores'
      end

      within('#indicator_1') do
        click_link 'Eliminar'
      end

      expect(page).to have_content 'Se ha eliminado correctamente el item'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).not_to have_content '1.1.1. Expedientes urbanísticos'
    end
  end

end
