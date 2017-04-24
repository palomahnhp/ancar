require 'rails_helper'

feature 'Supervisor Menu' do

  let(:user) { create(:user, :supervisor) }

  describe 'dashboard' do
    it 'muestra instrucciones' do
      visit supervisor_root_path
      expect(page).to have_content 'Configuración de procesos'
    end
  end

  describe 'opciones' do
    it 'muestra configurar Periodos' do
      visit supervisor_root_path
      expect(page).to have_link 'Configurar Periodos'
    end
    it 'muestra Resumen por procesos' do
      visit supervisor_root_path
      expect(page).to have_link 'Resumen por proceso'
    end
    it 'muestra Resumen por subproceso' do
      visit supervisor_root_path
      expect(page).to have_link 'Resumen por subproceso'
    end
  end
end
