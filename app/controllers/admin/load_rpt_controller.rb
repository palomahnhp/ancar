class Admin::LoadRptController < ApplicationController
  def index
    @year = Date.today.year - 1
    if params[:unit_id].present?
      @organization = Organization.find(params[:unit_id])
      @rpt  = Rpt.by_year(@year).by_organization(params[])
    else
      @organizations = Organization.all.order(:organization_type_id, :description)
    end
  end
end
