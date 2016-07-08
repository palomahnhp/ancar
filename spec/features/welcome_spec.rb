require 'rails_helper'

feature "Welcome screen" do

  scenario 'si no hay usuario conectado muestra mensaje' do
    visit root_path
    expect(page).to have_content("No se ha iniciado sesión: usuario no conectado")
  end

  scenario 'si hay usuario conectado muestra nombre' do
    user = create(:user)
    visit root_path(login: user.ayre)
   expect(page).to have_content("#{user.ayre} #{user.name} #{user.first_surname} #{user.second_surname}")
  end
end
