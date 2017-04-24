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
        expect(page).to have_content 'Rol administrador'
        expect(page).to have_content 'Rol validador'
        expect(page).to have_content 'Rol gestor'
        expect(page).to have_content 'Rol validador'
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

    scenario 'Añadir roles', :js  do
      click_link 'Usuarios y perfiles'
      click_link 'Rol gestor'

      fill_in 'search', with: 'Usu'
      find('input[name="commit"]').click

      expect(page).to have_content('Activo', count: 5)


      click_link('Añadir rol', match: :first)

      expect(page).to have_content 'There is 1 usuario'
      expect(page).to have_current_path(admin_roles_path, only_path: true)
      expect(page).to have_content('Usuario Activo', count: 1)
    end

    scenario 'Añadir recursos', :js do

      click_link 'Usuarios y perfiles'
      click_link 'Rol gestor'

      fill_in 'search', with: 'Usu'
      find('input[name="commit"]').click

      click_link('Añadir rol', match: :first)
      click_link 'Añadir recurso'

      expect(page).to have_content 'Añadir recurso'
      expect(page).to have_current_path(admin_roles_path, only_path: true)

      expect(page).to have_css("option", :count => 3)

      expect(page).to have_css('option', visible: true, text: 'JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA')
      expect(page).to have_css('option', visible: true, text: 'JUNTA MUNICIPAL DEL DISTRITO DE CENTRO')
      expect(page).to have_css('option', visible: true, text: 'JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS')

      find('#resource_id').find(:xpath, 'option[3]').select_option

      expect(page).not_to have_css('td', visible: true, text: 'JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS')

      find('input[name="add_resource"]').click

      expect(page).to have_css('td', visible: true, text: 'JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS')

    end

    scenario 'Eliminar recursos', :js do
      click_link 'Usuarios y perfiles'
      click_link 'Rol gestor'

      fill_in 'search', with: 'Usu'
      find('input[name="commit"]').click

      click_link('Añadir rol', match: :first)
      click_link 'Añadir recurso'
      find('#resource_id').find(:xpath, 'option[3]').select_option
      find('input[name="add_resource"]').click
#      find("td#button_destroy", match: :first).click_link '-'

    end
   scenario 'Eliminar roles'
  end
end
