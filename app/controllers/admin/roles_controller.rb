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
        format.js { render 'user_not_found' }
      end
    end
  end

  def destroy
    if @role.resource_type.nil?
      @user.revoke @role.name
    else
      resource_class = sanitize_resource_type(@role.resource_type)
      if resource_class.nil?
        flash[:error] = t('admin.roles.destroy_resource.error')
        redirect_to admin_roles_path(role_name: @role.name, user_id: @user.id )
      end
      @user.revoke @role.name, resource_class.find(@role.resource_id)
      redirect_to admin_roles_path(role_name: @role.name, user_id: @user.id )
     end
  end

  def create

    case params[:add_resource]
      when nil
        if scope_organization
          @user.add_role params[:role_name], scope_organization
        else
          @user.add_role params[:role_name]
        end
        redirect_to admin_roles_path(role_name: params[:role_name])
      when 'new'
        render :create
      when  t('admin.roles.add_resource.submit')
        resource_class = sanitize_resource_type(params[:resource_type])
        if resource_class.nil?
          flash[:error] = t('admin.roles.add_resource.error')
          render :create
        else
          resource_id = params[:resource_id]
          role_name = params[:role_name]
          if @user.add_role role_name, resource_class.find(resource_id)
            render :create
          end
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
      elsif params[:role_name] == 'supervisor'
        @user.organization.nil? ? false : @user.organization.organization_type
      end
    end

   def sanitize_resource_type(resource_type)
     [Organization, Unit, OrganizationType].find do |resource_class|
       resource_class.name == resource_type
     end
   end

end
