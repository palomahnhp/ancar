require 'rails_helper'

feature 'Admin dashboard' do

  background do
    admin = create(:admin)
    login_as_authenticated_user(admin)
    visit admin_root_path
  end

  context 'Menu options' do
    scenario 'show admin menu' do
      expect(page).to have_content 'Configuración de la aplicación'

      within("li#users") do
        expect(page).to have_content 'Usuarios'
        expect(page).to have_content 'Rol administrador'
        expect(page).to have_content 'Rol validador'
        expect(page).to have_content 'Rol gestor'
        expect(page).to have_content 'Rol supervisor'
      end

      within("li#organizations") do
        expect(page).to have_content 'Organizaciones'
        expect(page).to have_content 'Tipos de organizaciones'
        expect(page).to have_content 'Tipos de unidades'
        expect(page).to have_content 'Unidades'
        expect(page).to have_content 'Organizaciones'
      end

      within("li#settings") do
        expect(page).to have_content 'Configuración global'
      end

      within("li#stats") do
        expect(page).to have_content 'Estadísticas'
      end

    end

  end

  context 'Users' do
    background do
      1.upto(4) do
        create(:user, login: "USU" + Faker::Number.number(3),
                      uweb_id:  Faker::Number.number(8),
                      pernr: Faker::Number.number(8))
      end
      1.upto(2) do
        create(:user, login: "USU" + Faker::Number.number(3),
               uweb_id:  Faker::Number.number(8),
               pernr: Faker::Number.number(8),
               inactivated_at: Time.now - 1.month)
      end
    end

    scenario 'show users lists' do
      click_link 'Usuarios'

      expect(page).to have_content 'Actives'
      expect(page).to have_content 'Inactives'
      expect(page).to have_content 'All'

      expect(page).to have_content 'There are 5 usuarios'

      click_link 'Inactives'
      expect(page).to have_content 'There are 2 usuarios'

      click_link 'All'
      expect(page).to have_content 'There are 7 usuarios'

      click_link 'Actives'
      expect(page).to have_content 'There are 5 usuarios'

    end

    scenario 'Activar, desactivar usuarios'
    scenario 'Añadir roles'
    scenario 'Añadir recursos'
    scenario 'Eliminar recursos'
  end
end
