class Admin::UsersController < Admin::BaseController
  has_filters %w{all interlocutor validator consultor supervisor admin no_role inactive }

  before_action :set_user, only: [:edit, :show, :update, :destroy, :ws_update, :roles, :activate, :remove_role, :uweb_auth ]

  def index
    @users = load_filtered_users
  end

  def new
    @user = User.new()
  end

  def edit
  end

  def show
  end

  def destroy
    if @user.inactivate!(current_user.uweb_id)
      flash[:notice] = t('admin.users.destroy.notice', user: @user.login)
    else
      flash[:alert] = t('admin.users.destroy.alert', user: @user.login)
    end
     redirect_to edit_admin_user_path(@user, filter: params[:filter], page: params[:page])
  end

  def remove_role
    role = Role.find(params[:role])
    if role.resource_type.nil?
      @user.revoke role.name
    else
      resource_class = sanitize_resource_type(role.resource_type)
      if resource_class.nil?
        flash[:error] = t('admin.users.destroy_resource.error')
        redirect_to admin_roles_path(role_name: role.name, user_id: @user.id )
      end
      @user.revoke role.name, resource_class.find(role.resource_id)
      redirect_to edit_admin_user_path(@user, filter: params[:filter], page: params[:page])
    end
  end

  def activate
    if @user.activate!((current_user.uweb_id))
      flash[:notice] = t('admin.users.activate.notice', user: @user.login)
    else
      flash[:alert] = t('admin.users.activate.alert', user: @user.login)
    end
    redirect_to edit_admin_user_path(@user, filter: params[:filter], page: params[:page])
  end

  def create
    if params[:commit] == "Buscar datos"
      @user = User.new(user_params)
      if @user.validate
        unless @user.uweb_update
          @user.directory_update
          flash[:alert] = t('admin.users.create.alert')
        end
      end
      render :new
    else
      @user = User.create(user_params)
      redirect_to admin_users_path(anchor: @user.login, page: @user.page)
    end
  end

  def update
    @user.inactivated_at = nil if params[:status] == I18n.t('admin.users.status.inactive')
    @user.inactivated_at = DateTime.now if params[:status] == I18n.t('admin.users.status.active')

    if @user.save
      flash[:notice] =  t("admin.users.edit.message.#{params[:status]}")
    else
#      render :edit
      flas[:alert] =  t('admin.users.edit.message.error')
    end
    redirect_to admin_users_path(anchor: @user.login, filter: params[:filter], page: params[:page])
  end

  def uweb_auth
    if @user.uweb_on!(current_user.uweb_id)
      flash[:notice] =  t('admin.users.uweb_auth.message.success')
    else
      flash[:alert] =  t('admin.users.uweb_auth.message.error')
    end
    redirect_to edit_admin_user_path(@user, filter: params[:filter], page: params[:page])
  end

  def ws_update
    if @user.uweb_update!
      @user.directory_update!
      flash[:notice] = t('admin.users.uweb_update.success', user: @user.login)
    else
      flash[:alert] = t('admin.users.uweb_update.error', user: @user.login)
    end
    redirect_to edit_admin_user_path(@user, filter: params[:filter], page: params[:page])
  end

  def search
    search =  params[:search].split(/ /)
    login = (search.count == 1 ? search[0] : '').downcase
    first_word  = (search.count == 1 ? '%' + search[0] + '%' : '').downcase
    second_word =  (search.count > 1 ?  '%' + search[1] + '%' : '').downcase
    third_word  = (search.count > 2 ?  '%' + search[2] + '%' : '').downcase
    @users = User.active.where('(lower(login) = ? or lower(name) like ? or lower(surname) like ? or lower(surname) like ?
                              or lower(second_surname) like ? or lower(second_surname) like ?
                              or lower(second_surname) like ?)',
                               login, first_word, first_word, second_word, first_word, second_word, third_word)
    respond_to do |format|
      if @users.present?
        format.js
      else
        format.js { render 'user_not_found' }
      end
    end
  end

  def roles
    if params[:Organization].present?
      resource_class= Organization
      resource_id = params[:resource_id_1].to_i
      role_id = params[:role_1].to_i
    end
    if params[:OrganizationType].present?
      resource_class= OrganizationType
      resource_id = params[:resource_id_2].to_i
      role_id = params[:role_2].to_i
    end

    if resource_id > 0
      role_name = User::ROLES[role_id]
      if @user.add_role role_name, resource_class.find(resource_id)
        flash[:notice] = t('admin.roles.add_role.success')
      end
    else
      flash[:error] = t('admin.roles.add_role.error')
    end
    redirect_to edit_admin_user_path(@user, filter: params[:filter], page: params[:page])
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :surname, :second_surname, :login, :uweb_id, :pernr,
                                 :document_type, :document_number, :phone, :email, :official_position,
                                 :inactivated_at, :unit, :sap_id_unit, :sap_den_unit, :sap_den_organization, :sap_den_organization)
  end

  def load_filtered_users
    filter = params[:filter].nil? ? 'all' : params[:filter]
    case filter
      when 'all'       then User.active.page(params[:page]).distinct
      when 'inactive' then User.inactive.page(params[:page]).distinct
      when 'no_role'   then User.active.page(params[:page]).has_role(nil).distinct
      else
        User.active.with_role(params[:filter],:any).page(params[:page]).distinct
    end
  end

  def set_role
    @role = @user.roles.find(params[:id])
  end

  def scope_organization
    if params[:role_name] == 'interlocutor' || params[:role_name] == 'validator'
      organization = Organization.find_by_sap_id(@user.sap_id_organization)
    end
  end

  def sanitize_resource_type(resource_type)
    [Organization, Unit, OrganizationType].find do |resource_class|
      resource_class.name == resource_type
    end
  end

end
