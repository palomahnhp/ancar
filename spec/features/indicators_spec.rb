require 'rails_helper'

feature "Mantenimiento de Indicadores" do

  let(:user) { create(:user, :manager) }

  describe 'indice de indicadores' do
    it 'listado de indicadores' do
      ind1 = create(:indicator)
      ind2 = create(:indicator)
      visit manager_periods_path
      click_link "Configurar Periodos"

      page.find("#index_#{ind1.task.sub_process.main_process.period.id}").click
      page.find("#index_#{ind1.task.sub_process.main_process.id}").click

      page.find("#index_#{ind1.task.sub_process.id}").click

      page.find("#index_#{ind1.task.id}").click

#       expect(page).to have_content "Indicador 1"
    end

    it 'muestra botones si periodo abierto' do

    end

    it 'no muestra botones si periodo cerrado'
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
