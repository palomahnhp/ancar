require 'rails_helper'

  feature 'Indicator metrics Maintenance' do

    describe 'edit a indicator_metric' do
      it 'show the correct fields' do
        period_not_yet_opened

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
        within('tr#indicator_metric_1') do
          click_link 'Editar'
        end

        expect(page).to have_content 'Editar métrica '
        expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
        expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content '1.1.1. Contratos Menores'
        expect(page).to have_content 'Nº de Contratos recibidos'

        metric = page.find_field('indicator_metric_metric_id')
        expect(metric.text).to eq 'Nº de asuntos tratados en la Junta de Gobierno Nº de Contratos recibidos Nº de Contratos tramitados Nº de Expedientes Nº de proyectos de otras Áreas Nº informes solicitados por otras Áreas de Gobierno'
        expect(metric.tag_name).to eq('select')
        expect(metric.value).to eq('1')

        source = page.find_field('indicator_metric_indicator_sources_attributes_0_source_id')
        expect(source.text).to eq 'Elaboración propia Elaboración Propia PLYCA SIGSA'
        expect(source.tag_name).to eq('select')
        expect(source.value).to eq('1')

        button = page.find_button
        expect(button[:name]).to eq 'commit'
        expect(button.value).to eq 'Editar'
        expect(button.tag_name).to eq('input')
      end

      it 'changes indicator_metric order, metric and source with select options' do
        period_not_yet_opened

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
        within('tr#indicator_metric_1') do
          click_link 'Editar'
        end

        select('Nº de Contratos tramitados', :from => 'indicator_metric_metric_id')

        select('PLYCA', :from => 'indicator_metric_indicator_sources_attributes_0_source_id')

        click_button "Editar"

        expect(page).to have_content 'Indicadores'
        expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
        expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content '1.1.1. Contratos Menores'
        expect(page).to have_content 'Nº de Contratos tramitados'

        expect(page).to have_content('PLYCA', count: 1)

        within('tr#indicator_metric_1') do
          expect(page).to have_content 'E'
        end
      end
    end

    describe 'Validations' do
      it
    end
  end

