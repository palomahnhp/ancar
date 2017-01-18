class Admin::UsersController < Admin::BaseController
  has_filters %w{actives inactives all}

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = load_filtered_users
  end

  def new
  end

  def edit

  end

  def update
    @user.inactivated_at = nil if params[:status] == I18n.t('admin.users.status.inactive')
    @user.inactivated_at = DateTime.now if params[:status] == I18n.t('admin.users.status.active')

    if @user.save
      redirect_to admin_users_path, notice: t("admin.users.edit.message.#{params[:status]}")
    else
      render :edit
      redirect_to admin_users_path, notice: t("admin.users.edit.message.error")
    end
  end

  def destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :surname, :second_surname, :login, :uweb_id, :pernr,
                                 :document_type, :document_number, :phone, :email, :official_position,
                                 :inactivated_at, :unit)
  end

  def load_filtered_users
    case params[:filter]
      when "all"        then User.page(params[:page])
      when "actives"    then User.active.page(params[:page])
      when "inactives"  then User.inactive.page(params[:page])
      else
        User.active.page(params[:page])
    end
  end

end
