require 'rails_helper'

feature 'SubProcesses Maintenance' do

  describe 'Index of sub_procesess' do
    it 'show empty list of sub_processes ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)
      SubProcess.destroy_all
      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      expect(page).to have_content 'Organización: Distritos'
      expect(page).to have_content 'Periodo: Periodo de análisis de datos'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'

      expect(page).to have_content 'No hay subprocesos para este periodo'
    end

    it 'show list of sub_processes ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      expect(page).to have_content 'Organización: Distritos'
      expect(page).to have_content 'Periodo: Periodo de análisis de datos'
      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'

      expect(page).to have_content '1. 1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content '1. 2. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'
    end

    it 'has correct buttons for opened period ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      expect(page).to have_link 'Incluir subproceso'
      expect(page).to have_link 'Ver indicadores'

      expect(page).to have_link('Editar', count: 2)
      expect(page).to have_link('Eliminar', count: 2)
    end

    it 'has correct buttons for closed period ' do
      period = Period.first

      period.opened_at = Time.now - 2.days
      period.closed_at = Time.now - 1.day
      period.save

      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'

      within("#period_#{period.id}") do
        click_link('ver procesos', match:  :first)
      end
      click_link('Ver subprocesos', match: :first)

      expect(page).not_to have_link 'Incluir subproceso'
      expect(page).to have_link 'Ver indicadores'

      expect(page).not_to have_link 'Editar'
      expect(page).not_to have_link 'Eliminar'

    end

  end

  describe 'Create a new Subprocess' do

    it '1 error creating a new subprocess' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      click_link 'Incluir subproceso'

      find('#sub_process_item_id').find(:xpath, 'option[2]').select_option
      fill_in 'Núm. orden', with: 9

      click_button 'Crear'

      expect(page).to have_content("can't be blank", count: 1)
      expect(page).to have_content "1 error impidió guardar el subproceso:"

    end

    it 'more  than 1 error creating a new subprocess' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match: :first)
      click_link('Ver subprocesos', match: :first)
      click_link 'Incluir subproceso'

      fill_in 'Núm. orden', with: 9
      click_button 'Crear'

      expect(page).to have_content("can't be blank", count: 2)
      expect(page).to have_content "2 errores impidieron guardar el subproceso:"

    end

    it 'selecting description' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      click_link 'Incluir subproceso'

      find('#sub_process_unit_type_id').find(:xpath, 'option[3]').select_option
      find('#sub_process_item_id').find(:xpath, 'option[5]').select_option
      fill_in 'Núm. orden', with: 3
      click_button 'Crear'
      expect(page).to have_content I18n.t("supervisor.sub_processes.create.success")
      expect(page).to have_content 'DEPARTAMENTO DE SERVICIOS TECNICOS'
      expect(page).to have_content '1. 3. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'
    end

    it 'writing description' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      click_link 'Incluir subproceso'

      find('#sub_process_unit_type_id').find(:xpath, 'option[3]').select_option
      fill_in 'item_description', with: 'Nueva descripción'
      fill_in 'Núm. orden', with: 3
      click_button 'Crear'

      expect(page).to have_content I18n.t("supervisor.sub_processes.create.success")
      expect(page).to have_content 'DEPARTAMENTO DE SERVICIOS TECNICOS'
      expect(page).to have_content '1. 3. Nueva descripción'
    end
  end

  describe 'Edit a subprocess' do

    it "1 error editing subprocess" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match:  :first)
      click_link('Ver subprocesos', match: :first)

      click_link('Editar', match: :first)

      fill_in 'Núm. orden', with: ""

      click_button 'Editar'
      expect(page).to have_content("can't be blank", count: 1)
      expect(page).to have_content "1 error impidió guardar el subproceso:"
    end

    it "changing order in a subprocess" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match: :first)
      click_link('Ver subprocesos', match: :first)
      click_link('Editar', match: :first)

      fill_in 'Núm. orden', with: "4"

      click_button 'Editar'

      expect(page).to have_content "El registro se ha actualizado correctamente"

      expect(page).to have_content "1. 2. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO"
      expect(page).to have_content "1. 4. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO"
      expect(page).not_to have_content "1. 1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO"
    end

    it "changing description in a subprocess" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match: :first)
      click_link('Ver subprocesos', match: :first)
      click_link('Editar', match: :first)

      fill_in 'item_description', with: 'Nueva descripción'

      click_button 'Editar'

      expect(page).to have_content "El registro se ha actualizado correctamente"

      expect(page).to have_content "1. 2. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO"
      expect(page).to have_content "1. 1. Nueva descripción"
      expect(page).not_to have_content "1. 1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO"
    end

  end

  describe 'Delete a subrocess' do

    it "delete a subprocess" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link('ver procesos', match: :first)
      click_link('Ver subprocesos', match: :first)
      click_link('Eliminar', match: :first)

      expect(page).to have_content "Item eliminado"
      expect(page).to have_content "1. 2. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO"
      expect(page).not_to have_content "1. 1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO"
    end

    it "answer no to message question"
    it "delete a process"
  end

 end