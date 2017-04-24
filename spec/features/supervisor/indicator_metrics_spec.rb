require 'rails_helper'

  feature 'Indicator metrics Maintenance' do

    describe 'edit a indicator_metric' do
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
        within('tr#indicator_metric_1') do
          click_link 'Editar'
        end

        expect(page).to have_content 'Editar métrica '
        expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
        expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content '1.1.1. Contratos Menores'
        expect(page).to have_content 'Nº de Contratos recibidos'

        metric = page.find_field('indicator_metric_metric_id')
        expect(metric.text).to eq 'Nº de Contratos recibidos Nº de Contratos tramitados Nº de Expedientes'
        expect(metric.tag_name).to eq('select')
        expect(metric.value).to eq('1')

        source = page.find_field('source_id')
        expect(source.text).to eq 'FuentePLYCA SIGSA'
        expect(source.tag_name).to eq('select')
        expect(source.value).to eq('1')

        source = page.find_field('Proceso')
        expect(source.text).to eq 'No acumula Entrada Salida Único Acumula'
        expect(source.tag_name).to eq('select')
        expect(source.value).to eq('3')

        source = page.find_field('Subproceso')
        expect(source.text).to eq 'No acumula Entrada Salida Único Acumula'
        expect(source.tag_name).to eq('select')
        expect(source.value).to eq('1')

        source = page.find_field('Stock')
        expect(source.text).to eq 'No acumula Entrada Salida Único Acumula'
        expect(source.tag_name).to eq('select')
        expect(source.value).to eq('5')

        button = page.find_button
        expect(button[:name]).to eq 'commit'
        expect(button.value).to eq 'Editar'
        expect(button.tag_name).to eq('input')
      end

      it 'changes indicator_metric order, metric and source with select options' do
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
        within('tr#indicator_metric_1') do
          click_link 'Editar'
        end

        select('Nº de Contratos tramitados', :from => 'indicator_metric_metric_id')
        select('PLYCA', :from => 'source_id')
        select('No acumula', :from => 'Proceso')
        select('Salida', :from => 'Subproceso')

        click_button "Editar"

        expect(page).to have_content 'Indicadores'
        expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
        expect(page).to have_content '1.1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content '1.1.1. Contratos Menores'
        expect(page).to have_content 'Nº de Contratos tramitados'

        expect(page).to have_content('PLYCA', count: 1)

        within('tr#indicator_metric_1') do
          within('td#summary_type_1') do
            expect(page).to have_content '-'
          end
          within('td#summary_type_2') do
            expect(page).to have_content 'S'
          end
          within('td#summary_type_3') do
            expect(page).to have_content 'U'
          end
        end
      end
    end

    describe 'Validations' do
      it
    end
  end

