require 'rails_helper'

describe SessionsController do

  describe 'Sign in' do
    it "usuario YA existe en la aplicación actualizar sus datos", :pending => true do
      uweb_user = {login: "MMM01", user_key: "31415926" , date: "20151031135905", nombre: 'MARÍA', apellido1: 'MINAS', apellido2: 'MERAS', cargo: "JEFE/A DEPARTAMENTO"}
      user = create(:user, login: "MMM001")
      uweb_cliente = UwebAuthenticator.new
      allow_any_instance_of(UwebAuthenticator).to receive(:auth).and_return(uweb_user)
      get :create, login: "MMM001"

      expect(session[:user_id]).to eq user.id

      user = User.find_by_login("MMM001")
      expect(user.cargo).to eq("JEFE/A DEPARTAMENTO")

      expect(page).to_have "MARÍA MINAS MERAS"
    end

    it "usuario NO existe en la aplicación crearlo en la BD con la unidad de nivel 1", :pending => true do
      uweb_user = {login: "MMM01", user_key: "31415926" , date: "20151031135905",
                  nombre: 'MARÍA', apellido1: 'MINAS', apellido2: 'MERAS',
                  cargo: "JEFE/A DEPARTAMENTO"}
      uweb_cliente = UwebAuthenticator.new
      allow_any_instance_of(UwebAuthenticator).to receive(:auth).and_return(false)
      user = User.find_by_login("MMM001")
      expect(session[:user_id]).to eq user.id
      expect(page).to_have "MARÍA MINAS MERAS"
    end
  end

  describe 'Sign out'  do
    it "destruye la sesión y redirect"

  end

end