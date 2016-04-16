class Admin::SubProcessesController < Admin::BaseController

   def index
    debugger
    if params[:commit] == t("admin.sub_processes.index.submit")
      if params[:sub_processes].nil?
          period_id = params[:period_id]
          organization_type_id = params[:organization_type_id]
          main_process_id = params[:main_process__id]
      else
          period_id =  params[:sub_processes][:period_id]
          organization_type_id = params[:sub_processes][:organization_type_id]
          main_process_id = params[:sub_processes][:main_process_id]
      end
      @sub_processes = SubProcess.where("main_process_id = ?", main_process_id)
      @organization_type = OrganizationType.find(organization_type_id)
      @period = Period.find(period_id)
      @main_process = Period.find(main_process_id)
    end
      @organization_types = OrganizationType.all
      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
      @main_process = MainProcess.where("main_process_id = ?", @periods.first.id)
  end


   def show
    @sub_process = SubProcess.find_by("id = ?", params[:main_process])
   end

end
