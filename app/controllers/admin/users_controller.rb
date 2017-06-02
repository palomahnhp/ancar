class Admin::UsersController < Admin::BaseController
  has_filters %w{all interlocutor validator consultor supervisor admin no_role inactive }

  before_action :set_user, only: [:edit, :show, :update, :destroy, :ws_update, :roles ]

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

  def create
    if params[:commit] == "Buscar datos"
      @user = User.new(user_params)
      if @user.validate
        unless @user.uweb_update && @user.directory_update
          flash[:alert] = t('admin.users.create.alert')
        end
      end
      render :new
    else
      @user = User.create(user_params)
      redirect_to admin_users_path(filter: 'no_role', anchor: @user.login)
    end
  end

  def update
    @user.inactivated_at = nil if params[:status] == I18n.t('admin.users.status.inactive')
    @user.inactivated_at = DateTime.now if params[:status] == I18n.t('admin.users.status.active')

    if @user.save
      flash[:notice] =  t("admin.users.edit.message.#{params[:status]}")
    else
#      render :edit
      flas[:notice] =  t('admin.users.edit.message.error')
    end
    redirect_to admin_users_path(filter: params[:filter], page: params[:page])
  end

  def ws_update
    if @user.uweb_update! && @user.directory_update!
      flash[:notice] = t('admin.users_controller.uweb_update.success', user: @user.login)
    else
      flash[:alert] = t('admin.users_controller.uweb_update.error', user: @user.login)
    end
    redirect_to admin_users_path(filter: params[:filter], page: params[:page])
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
    case params[:add_resource]
      when nil
        if scope_organization.present?
          @user.add_role params[:role_name], scope_organization
        else
          @user.add_role params[:role_name]
        end
        redirect_to admin_roles_path(role_name: params[:role_name])
      when 'new'
        render :edit
      when  t('admin.roles.add_resource.submit')
        resource_class = sanitize_resource_type(params[:resource_type])
        if resource_class.nil?
          flash[:error] = t('admin.roles.add_resource.error')
          render :edit
        else
          resource_id = params[:resource_id]
          role_name = params[:role_name]
          if @user.add_role role_name, resource_class.find(resource_id)
            render :edit
          end
        end
    end
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
      when 'inactives' then User.inactive.page(params[:page]).distinct
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
