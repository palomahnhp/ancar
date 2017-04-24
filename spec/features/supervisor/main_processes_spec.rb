require 'rails_helper'

feature 'MainProcesses Maintenance' do

  describe 'Index of main_procesess' do
    it 'show empty list of processes ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)
      MainProcess.destroy_all
      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      expect(page).to have_content 'Organización: Distritos'
      expect(page).to have_content 'Periodo: Periodo de análisis de datos'

      expect(page).to have_content 'No hay procesos para este periodo'
    end

    it 'show list of processes ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      expect(page).to have_content 'Organización: Distritos'
      expect(page).to have_content 'Periodo: Periodo de análisis de datos'

      expect(page).to have_content '1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS'
      expect(page).to have_content '2. AUTORIZACIONES Y CONCESIONES'
    end

    it 'has correct buttons for opened period ' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path

      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      expect(page).to have_link 'Incluir procesos'
      expect(page).to have_link 'Ver subprocesos'
      expect(page).to have_link 'Editar'
      expect(page).to have_link 'Eliminar'
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
      click_link 'ver procesos'

      expect(page).not_to have_link 'Incluir procesos'

      expect(page).to have_link 'Ver subprocesos'
      expect(page).not_to have_link 'Editar'
      expect(page).not_to have_link 'Eliminar'

    end

  end

  describe 'Create a new Process' do

    it "1 error creating a new process" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      click_link 'Incluir procesos'
      fill_in 'Núm. orden', with: 1

      click_button 'Crear'

      expect(page).to have_content("can't be blank", count: 1)
      expect(page).to have_content "1 error impidió guardar el proceso:"

    end

    it "more than 1 error creating a new process" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      click_link 'Incluir procesos'

      click_button 'Crear'

      expect(page).to have_content("can't be blank", count: 2)
      expect(page).to have_content "2 errores impidieron guardar el proceso:"

    end

    it "create a new process selecting description" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'
      click_link 'Incluir procesos'

      find('#main_process_item_id').find(:xpath, 'option[2]').select_option
      fill_in 'Núm. orden', with: 9
      find('#main_process_item_id').find(:xpath, 'option[2]').select_option
      click_button 'Crear'

      expect(page).to have_content I18n.t("supervisor.main_processes.create.success")
      expect(page).to have_content '9. AUTORIZACIONES Y CONCESIONES'

    end

    it "create a new process writing description" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      click_link 'Incluir procesos'

      fill_in 'item_description', with: 'Nueva descripción'
      fill_in 'Núm. orden', with: 9

      click_button 'Crear'

      expect(page).to have_content I18n.t("supervisor.main_processes.create.success")
      expect(page).to have_content '9. Nueva descripción'
    end

    it "create a new process selecting and writing description" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      click_link 'Incluir procesos'

      find('#main_process_item_id').find(:xpath, 'option[2]').select_option
      fill_in 'item_description', with: 'Nueva descripción'
      fill_in 'Núm. orden', with: 9

      click_button 'Crear'

      expect(page).to have_content I18n.t("supervisor.main_processes.create.success")
      expect(page).to have_content '9. Nueva descripción'
    end


  end

  describe 'Edit a Process' do

    it "1 error editing process" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'
      click_link('Editar', match: :first)

      fill_in 'Núm. orden', with: ""

      click_button 'Editar'
      expect(page).to have_content("can't be blank", count: 1)
      expect(page).to have_content "1 error impidió guardar el proceso:"
    end

    it "changing order in a process" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'
      click_link('Editar', match: :first)

      fill_in 'Núm. orden', with: "4"

      click_button 'Editar'

      expect(page).to have_content "El registro se ha actualizado correctamente"
      expect(page).to have_content "2. AUTORIZACIONES Y CONCESIONES"
      expect(page).to have_content "4. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
      expect(page).not_to have_content "1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
    end

    it "changing description by select options" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'
      click_link('Editar', match: :first)

      find('#main_process_item_id').find(:xpath, 'option[1]').select_option

      click_button 'Editar'

      expect(page).to have_content "El registro se ha actualizado correctamente"
      expect(page).to have_content "2. AUTORIZACIONES Y CONCESIONES"
      expect(page).to have_content "1. AUTORIZACIONES Y CONCESIONES"
      expect(page).not_to have_content "1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
    end

    it "changing description by writing it" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'
      click_link('Editar', match: :first)

      fill_in 'item_description', with: 'Nueva descripción'

      click_button 'Editar'

      expect(page).to have_content "El registro se ha actualizado correctamente"
      expect(page).to have_content "2. AUTORIZACIONES Y CONCESIONES"
      expect(page).to have_content "1. Nueva descripción"
      expect(page).not_to have_content "1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
    end

    it "changing description by select and writing it together" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'
      click_link('Editar', match: :first)

      find('#main_process_item_id').find(:xpath, 'option[2]').select_option
      fill_in 'item_description', with: 'Nueva descripción'

      click_button 'Editar'

      expect(page).to have_content "El registro se ha actualizado correctamente"
      expect(page).to have_content "2. AUTORIZACIONES Y CONCESIONES"
      expect(page).to have_content "1. Nueva descripción"
      expect(page).not_to have_content "1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
    end

  end

  describe 'Delete a Process' do

    it "delete a process" do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)

      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
      click_link 'Configurar Periodos'
      click_link 'ver procesos'

      click_link('Eliminar', match: :first)
      expect(page).to have_content "Item eliminado"
      expect(page).to have_content "2. AUTORIZACIONES Y CONCESIONES"
      expect(page).not_to have_content "1. TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"

    end

    it "answer no to message question"
    it "delete a process"
  end

 end