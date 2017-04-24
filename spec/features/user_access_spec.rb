require 'rails_helper'
include CommonActions

feature "User access" do

  describe 'admin' do
    it 'has rol with global scope' do
      admin= create(:admin)
      login_as_authenticated_user(admin)
      user_with_global_scope
    end
  end

  describe 'validator' do
    it 'has rol with global scope' do
      supervisor = create(:supervisor_global)
      login_as_authenticated_user(supervisor)
      user_with_global_scope
    end

    it 'has role with all OrganizationType' do
      supervisor = create(:supervisor_with_all_organization_types)
      login_as_authenticated_user(supervisor)

      user_with_global_scope
    end

    it 'has role with one OrganizationType' do
      supervisor = create(:validator)

      supervisor.add_role(:validator, OrganizationType.first)

      login_as_authenticated_user(supervisor)

      click_link("Procesos y subprocesos", :match => :first)

      expect(page).to have_content "Hoja de identificación de procesos"
      expect(page).to have_content "Selección de unidad a tratar"
      expect(page).to have_content "Distritos"
      expect(page).not_to have_content "Secretarías Generales Técnicas"

      click_link "Distritos"

      expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA"
      expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS"
      expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE CENTRO"
      expect(page).to have_content "Periodo"
    end
  end

  describe 'user' do
    it 'has no role' do
      user = create(:user)
      login_as_authenticated_user(user)
      click_link("Procesos y subprocesos", :match => :first)

      expect(page).to have_content "Hoja de identificación de procesos"
      expect(page).to have_content "Selección de unidad a tratar"
      expect(page).to have_content "No tienes unidades autorizadas"

    end

    it 'has role with one Organization' do
      user = create(:user, :with_one_organization)

      login_as_authenticated_user(user)
      click_link("Procesos y subprocesos", :match => :first)

      expect(page).to have_content "Hoja de identificación de procesos"
      expect(page).to have_content "Selección de unidad a tratar"
      expect(page).not_to have_content "Distritos"
      expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA"
      expect(page).to have_content "Periodo"
    end

    it 'has roles with more than one Organizations' do
      user = create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      click_link("Procesos y subprocesos", :match => :first)
      expect(page).to have_content "Hoja de identificación de procesos"
      expect(page).to have_content "Selección de unidad a tratar"
      expect(page).not_to have_content "Distritos"
      expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS"
      expect(page).to have_content "Periodo"
      expect(page).to have_content "JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA"
    end
  end

end
