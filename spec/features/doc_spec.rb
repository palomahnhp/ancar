require 'rails_helper'

feature "Instrucciones y manuales" do
  background do
    doc1 = create(:doc, :general_access)
    doc2 = create(:doc, :instructions_jd)
    doc3 = create(:doc, :instructions_sgt)

    doc2.organization_type  = OrganizationType.find_by_acronym('JD')
    doc2.save

    doc3.organization_type  = OrganizationType.find_by_acronym('SGT')
    doc3.save
  end

  scenario 'Muestra documentos a usuario de SGT' do
    user = create(:user, :interlocutor_sgt)

    login_as_authenticated_user(user)

    click_link("Instrucciones y manuales", :match => :first)

    expect(page).to have_content("Documento acceso general")
    expect(page).to have_content("Instrucciones SGTs")
    expect(page).not_to have_content("Instrucciones Distritos")
  end

  scenario 'Muestra documentos a administrador' do
    user = create(:admin, name: 'Administrador', surname: 'Activo' )

    login_as_authenticated_user(user)

    click_link("Instrucciones y manuales", :match => :first)

    expect(page).to have_content("Documento acceso general")
    expect(page).to have_content("Instrucciones SGTs")
    expect(page).to have_content("Instrucciones Distritos")
  end

end
