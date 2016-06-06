class UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    if @user_save
      session[:user_id] = @user.user_id
        redirect_to root_url
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :first_surname, :second_surname, :ayre, :phone )
  end

end
