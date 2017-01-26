class Admin::RolesController < Admin::BaseController

  before_action :set_user, only: [:create, :create, :destroy]
  before_action :set_role, only: [:destroy]

  def index
    @users = User.active.with_role(params[:role_name], :any).page(params[:page]).distinct
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
      if @users
        format.js
      else
        format.js { render "user_not_found" }
      end
    end
  end

  def destroy
    @user.revoke @role.name, (Object.const_get @role.resource_type).find(@role.resource_id) unless @role.resource_type.nil?
    @user.revoke @role.name if @role.resource_type.nil?
    redirect_to admin_roles_path(role_name: @role.name, user_id: @user.id )
  end

  def create
    unless  params[:add_resource]
      @user.add_role params[:role_name] unless scope_organization
      @user.add_role params[:role_name], scope_organization if scope_organization
      redirect_to admin_roles_path(role_name: params[:role_name])
    end

    if params[:add_resource] == 'new'
      render :create
    elsif params[:add_resource] == t('admin.roles.add_resource.submit')
      if @user.add_role params[:role_name], (Object.const_get params[:resource_type]).find(params[:resource_id])
        render :create
      end
    end
  end


  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_role
      @role = @user.roles.find(params[:id])
    end

    def scope_organization
      if params[:role_name] == 'unit_user' || params[:role_name] == 'validator'
        @user.organization
      elsif params[:role_name] == 'manager'
        @user.organization.nil? ? false : @user.organization.organization_type
      end
    end
end
