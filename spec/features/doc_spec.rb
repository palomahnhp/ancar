require 'rails_helper'

feature "Instrucciones y manuales" do

  scenario 'Muestra documentos a usuario de SGT' do
    create(:doc, :general_access)
    create(:doc, :instructions_jd)
    create(:doc, :instructions_sgt)

    user = create(:user, :interlocutor_sgt)
    login_as_authenticated_user(user)

    click_link("Instrucciones y manuales", :match => :first)

    expect(page).to have_content("Documento acceso general")
    expect(page).to have_content("Instrucciones SGTs")
    expect(page).not_to have_content("Instrucciones Distritos")
  end

end
