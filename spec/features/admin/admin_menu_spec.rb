require 'rails_helper'

feature 'Admin dashboard' do

  background do
    admin = create(:admin, name: 'Administrador', surname: 'Activo' )
    login_as_authenticated_user(admin)
    visit admin_root_path
  end

  context 'Menu options' do
    scenario 'show admin menu' do
      expect(page).to have_content 'Configuración de la aplicación'

      within("li#users") do
        expect(page).to have_content 'Usuarios'
      end

      within("li#organizations") do
        expect(page).to have_content 'Organizaciones'
        expect(page).to have_content 'Tipos de organizaciones'
        expect(page).to have_content 'Tipos de unidades'
        expect(page).to have_content 'Unidades'
      end

      within("li#settings") do
        expect(page).to have_content 'Configuración global'
      end

      within("li#console") do
        expect(page).to have_content 'Consola de administración'
      end

      within("li#sidekiq") do
        expect(page).to have_content 'Jobs asíncronos'
      end
    end
  end

  context 'Users' do
    background do
      1.upto(4) do
        create(:user, login: "USU" + Faker::Number.number(3),
                      name: "Usuario",
                      surname: "Activo",
                      second_surname: "Apellido 2_" + Faker::Number.number(3),
                      uweb_id:  Faker::Number.number(8),
                      pernr: Faker::Number.number(8))
      end
      1.upto(2) do
        create(:user, login: "USU" + Faker::Number.number(3),
               uweb_id:  Faker::Number.number(8),
               pernr: Faker::Number.number(8),
               name: "Usuario",
               surname: "Inactivo",
               second_surname: "Apellido 2_" + Faker::Number.number(3),
               inactivated_at: Time.now - 1.month)
      end
    end

    scenario 'show users lists' do
      click_link 'Usuarios'

      within("span#user_tabs") do
        expect(page).to have_content 'Todos'
        expect(page).to have_content 'Interlocutores'
        expect(page).to have_content 'Validadores'
        expect(page).to have_content 'Consultores'
        expect(page).to have_content 'Supervisores'
        expect(page).to have_content 'Administradores'
        expect(page).to have_content 'Sin autorizaciones'
        expect(page).to have_content 'Inactivos'
      end

      expect(page).to have_link 'Alta de usuario'

      expect(page).to have_content ' 5 usuarios'

      click_link 'Inactivos'
      expect(page).to have_content 'Mostrando un total de 2 usuarios'

      click_link 'Sin autorizaciones'
      expect(page).to have_content 'Mostrando un total de 4 usuarios'

      click_link 'Administradores'
      expect(page).to have_content 'Mostrando 1 usuario'
    end

    scenario 'Activar, desactivar usuarios'
    scenario 'Añadir roles'
    scenario 'Añadir recursos'
    scenario 'Eliminar recursos'
    scenario 'Eliminar roles'
  end
end
