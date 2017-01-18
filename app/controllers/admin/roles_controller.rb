class Admin::RolesController < Admin::BaseController

  before_action :set_user, only: [:create, :destroy, :add_resource, :remove_resource]
  before_action :set_role, only: [:remove_resource]

  def index
    @users = User.active.with_role(params[:role], :any).page(params[:page]) # load_filtered_roles
  end

  def load_filtered_roles

    case params[:role]
      when "unit_user"  then User.active.with_role(:unit_user, :any).page(params[:page])
      when "validator"  then User.active.with_role(:validator, :any).page(params[:page])
      when "manager"    then User.active.with_role(:manager, :any).page(params[:page])
      when "admin"      then User.active.with_role(:admin, :any).page(params[:page])
     end
  end

  def search
    search =  params[:search].split(/ /)
    login =           search.count == 1 ? search[0].upcase : ''
    first_word  =           search.count == 1 ? '%' + search[0].upcase + '%' : ''
    second_word =        search.count > 1 ?  '%' + search[1].upcase + '%' : ''
    third_word  = search.count > 2 ?  '%' + search[2].upcase + '%' : ''

#   @roles = User.where(login: params[:search] || name: full_name[0])
    @users = User.where("login = ? or name like ? or surname like ? or surname like ? or second_surname like ? or second_surname like ?
                         or second_surname like ? ",
                        login, first_word, first_word, second_word, first_word, second_word, third_word)

    respond_to do |format|
      if @users
        format.js
      else
        format.js { render "user_not_found" }
      end
    end
  end

  def create
    @user.add_role params[:role] unless scope_organization
    @user.add_role params[:role], scope_organization if scope_organization
    redirect_to admin_roles_path(role: params[:role])
  end

  def destroy
    @user.revoke params[:role], :any
    redirect_to admin_roles_path(role: params[:role])
  end

  def add_resource
    if params[:commit]
      if @user.add_role params[:role], (Object.const_get params[:resource_type]).find(params[:resource_id])
        render :add_resource
      end
    end
    @roles = @user.roles params[:role]
    @role = nil
  end

  def remove_resource

  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_role
      @role = @user.roles.find(params[:role])
    end

    def scope_organization
      if params[:role] == 'unit_user' || params[:role] == 'validator'
        @user.organization
      elsif params[:role] == 'manager'
        @user.organization.organization_type
      end
    end
end
