class UsersController < ApplicationController

#  after_create :assign_default_role

  def create
    @user = User.new(user_params)
    user = params[:user]
    @user.login = user[:login]
    @user.uweb_id = user[:clave_ind]
    @user.name = user[:nombre_usuario]
    @user.surname = user[:apellido1_usuario]
    @user.second_surname = user[:apellido2_usuario]
    @user.document_number = user[:dni]
    @user.document_type = ' '
    @user.phone = user[:telefono]
    @user.pernr = user[:numero_personal]
    @user.email = user[:mail]
    @user.adscripcion = user[:unidad]
    @user.official_position = user[:cargo]

    if @user.save then
      session[:user_id] = @user.id
      redirect_to root_url
    else
     redirect_to root_url notice: 'error creando usuario'
    end
  end

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  private
    def user_params
      params.require(:user).permit(:login, :uweb_id, :name, :surname, :second_surname, :document_number, :document_type, :email, :phone)
    end
end
