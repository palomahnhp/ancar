class Admin::SubProcessesController < Admin::BaseController

   def index
    if params[:commit] == t("admin.sub_processes.index.submit")
      if params[:sub_processes].nil?
        main_process_id = params[:main_process_id]
      else
        period_id =  params[:sub_processes][:period_id]
        organization_type_id = params[:sub_processes][:organization_type_id]
        main_process_id = params[:sub_processes][:main_process_id]
      end
      @sub_processes = SubProcess.where("main_process_id = ?", main_process_id)
      @main_process = MainProcess.find(main_process_id)
      @period = Period.find(@main_process.period_id)
      @organization_type = OrganizationType.find(@period.organization_type_id)
    end
      @organization_types = OrganizationType.all
      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
      @main_processes = MainProcess.where("main_process_id = ?", @periods.first.id)
  end

   def show
    @sub_process = SubProcess.find_by("id = ?", params[:main_process])
   end

end
