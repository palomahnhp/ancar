class UserAccessController < ApplicationController

  def index

#     if !params[:select_view]
#       if params[:organization_type_id]
#          @periods = Period.where(organization_type_id: params[:organization_type_id]).order(started_at: :desc)
#       elsif (current_user.has_any_role? :admin,
#          { :name => :manager, :resource => OrganizationType},
#          { :name => :visitor, :resource => OrganizationType})
#         redirect_to user_access_index_path(select_view: "organization_types")

#       # Solo tiene una organización autorizada, o ya ha seleccionado la que quiere tratar
#       elsif (current_user.has_any_role? :admin,
#          { :name => :manager, :resource => Organization},
#          { :name => :visitor, :resource => Organization} )
#         @periods = Period.where(organization_type_id: current_user.organizations.first.organization_type_id)
#         redirect_to user_access_index_path(select_view: "organizations")
#       else !current_user.has_organizations? # Error: no tiene organizaciones autorizadas
#         redirect_to root_path, notice: t("entry_indicators.flash.no_units_authorized")
# #      elsif current_user.organizations_unique?  || (!params[:organization_id].nil? && !params[:organization_id].empty?)
#       end
#     elsif params[:select_view] == "organizations"
#       @periods = Period.where(organization_type_id: current_user.organizations.first.organization_type_id)
#     end
  end

  def show
  end

end