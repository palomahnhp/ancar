class Manager::TasksController < Manager::BaseController

   def index
    if params[:commit] == t("manager.tasks.index.submit")
      if params[:tasks].nil?
        sub_process_id = params[:sub_process_id]
      else
#        3period_id =  params[:tasks][:period_id]
#        organization_type_id = params[:tasks][:organization_type_id]
#        main_process_id = params[:tasks][:main_process_id]
        sub_process_id = params[:tasks][:sub_process_id]
      end

      @tasks = Task.where("sub_process_id = ?", sub_process_id)
      @sub_process = SubProcess.find(sub_process_id)
      @main_process = MainProcess.find(@sub_process.main_process_id)
      @period = Period.find(@main_process.period_id)
      @organization_type = OrganizationType.find(@period.organization_type_id)
    end
      @organization_types = OrganizationType.all
      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
      @main_processes = MainProcess.where("period_id = ?", @periods.first.id)
      @sub_processes = SubProcess.where("main_process_id = ?", @main_processes.first.id)
  end

   def show
    @task = Task.find_by("id = ?", params[:sub_process])
   end

end
