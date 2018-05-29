class Shared::UsersController < ApplicationController
  layout 'admin'

  before_action :valid_filters, only: [ :index ]
  before_action :set_user, only: [ :edit, :show, :update, :destroy, :ws_update, :roles, :activate, :remove_role, :uweb_auth ]
  has_filters []

  def index
    if params[:format].present?
      @users = User.auth(current_user).distinct
    else
      @users = load_filtered_users
    end
    respond_to do |format|
      format.html
      format.xls
      format.xml  { render xml: @users }
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
  end

  def destroy
    if @user.inactivate!(current_user.uweb_id)
      flash[:notice] = t('shared.users.destroy.notice', user: @user.login)
    else
      flash[:alert] = t('shared.users.destroy.alert', user: @user.login)
    end
     redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  def remove_role
    role = @user.roles.find(params[:role])
    if role.resource_type.nil?
      @user.revoke role.name
    else
      resource_class = sanitize_resource_type(role.resource_type)
      if resource_class.nil?
        flash[:error] = t('shared.users.destroy_resource.error')
        redirect_to eval("#{params[:controller].split("/").first}_roles_path(role_name: #{role.name}, user_id: #{@user.id})")
      end
      @user.revoke role.name, resource_class.find(role.resource_id)
    end
    redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  def activate
    if @user.activate!(current_user.uweb_id)
      flash[:notice] = t('shared.users.activate.notice', user: @user.login)
    else
      flash[:alert] = t('shared.users.activate.alert', user: @user.login)
    end
    redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  def create
    if params[:commit] == "Buscar datos"
      @user = User.new(user_params)
      if @user.validate
        if @user.uweb_update
          @user.directory_update
        else
          flash[:alert] = t('shared.users.create.alert')
        end
      end
      render :new
    else
      @user = User.create(user_params)
#      @user.directory_update!
      redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
    end
  end

  def update
    @user.inactivated_at = nil if params[:status] == I18n.t('shared.users.status.inactive')
    @user.inactivated_at = Time.zone.now if params[:status] == I18n.t('shared.users.status.active')

    if @user.save
      flash[:notice] =  t("shared.users.edit.message.#{params[:status]}")
    else
#      render :edit
      flash[:alert] =  t('shared.users.edit.message.error')
    end
    redirect_to eval("#{params[:controller].split("/").first}_users_path(anchor: #{@user.login}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  def update_all
    UsersUpdateJob.perform_later
#    UsersUpdate.new.run
    flash[:notice] =  'Lanzada tarea de actualizacion. Disponible en unos minutos'
    redirect_to eval("#{params[:controller].split("/").first}_users_path")
  end

  def uweb_auth
    if @user.uweb_on!(current_user.uweb_id)
      flash[:notice] =  t('shared.users.uweb_auth.message.success')
    else
      flash[:alert] =  t('shared.users.uweb_auth.message.error')
    end
    redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  def ws_update
    if @user.uweb_update!
      @user.directory_update!
      flash[:notice] = t('shared.users.uweb_update.success', user: @user.login)
    else
      flash[:alert] = t('shared.users.uweb_update.error', user: @user.login)
    end
    redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  def search
    search =  params[:search].split(/ /)
    login = (search.count == 1 ? search[0] : '').downcase
    first_word  = (search.count == 1 ? '%' + search[0] + '%' : '').downcase
    second_word =  (search.count > 1 ?  '%' + search[1] + '%' : '').downcase
    third_word  = (search.count > 2 ?  '%' + search[2] + '%' : '').downcase
    @users = User.where('(lower(login) = ? or lower(name) like ? or lower(surname) like ? or lower(surname) like ?
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
    elsif params[:OrganizationType].present?
      resource_class= OrganizationType
      resource_id = params[:resource_id_2].to_i
      role_id = params[:role_2].to_i
    elsif params[:Supervisor].present?
      role_id = params[:role_3].to_i
    end

    role_name = User::ROLES[role_id]
    if resource_id.present? && resource_id > 0
      flash[:notice] = t('shared.roles.add_role.success') if @user.add_role role_name, resource_class.find(resource_id)
    elsif params[:Supervisor].present?
      flash[:notice] = t('shared.roles.add_role.success') if @user.add_role role_name
    else
      flash[:error] = t('shared.roles.add_role.error')
    end
    redirect_to eval("edit_#{params[:controller].split("/").first}_user_path(#{@user}, filter: #{params[:filter]}, page: #{params[:page]})")
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :surname, :second_surname, :login, :uweb_id, :pernr,
                                 :document_type, :document_number, :phone, :email,
                                 :official_position,:inactivated_at,
                                 :unit, :sap_id_unit,:sap_den_unit,
                                 :sap_id_organization, :sap_den_organization)
  end

  def load_filtered_users
    filter = params[:filter].nil? ? 'all' : params[:filter]
    case filter
    when 'all'      then User.active.auth(current_user).page(params[:page]).distinct
    when 'inactive' then User.inactive.auth(current_user).page(params[:page]).distinct
    when 'no_role'  then User.active.auth(current_user).page(params[:page]).has_role(nil).distinct
    else
      User.active.auth(current_user).with_role(params[:filter], :any).page(params[:page]).distinct
    end
  end

  def set_role
    @role = @user.roles.find(params[:id])
  end

  def scope_organization
    Organization.find_by(sap_id: @user.sap_id_organization) if (params[:role_name] == 'interlocutor' || params[:role_name] == 'validator')
  end

  def sanitize_resource_type(resource_type)
    [Organization, Unit, OrganizationType].find do |resource_class|
      resource_class.name == resource_type
    end
  end

  def valid_filters
    if current_user.has_role? :admin
      @valid_filters= %w[ all interlocutor validator supervisor consultor admin no_role inactive ]
    elsif current_user.has_role?(:supervisor, :any)
      @valid_filters = %w[ all interlocutor validator no_role inactive]
    end
  end
end
