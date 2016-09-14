require 'rails_helper'

feature "Welcome screen" do

  scenario 'si no hay usuario conectado muestra mensaje' do
    visit root_path
    expect(page).to have_content("No se ha iniciado sesión: usuario no conectado")
  end

  scenario 'si hay usuario conectado muestra nombre'

end
