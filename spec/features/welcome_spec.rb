require 'rails_helper'

feature "Welcome screen" do

  scenario 'si no hay usuario conectado muestra mensaje' do
    visit root_path
    expect(page).to have_content("No hay usuario conectado ")
  end

  scenario 'si hay usuario conectado muestra nombre' do
    user = create(:user)
    login_as_authenticated_user(user)
    expect(page).to have_content("Nombre1 Apellido_1_1 Apellido_2_1")
  end

end
