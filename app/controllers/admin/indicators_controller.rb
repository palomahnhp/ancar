class Admin::IndicatorsController < Admin::BaseController
#   load_and_authorize_resource
  before_action :set_indicator, only: [:show, :edit, :update, :destroy]

  def index
    if params[:commit] == t("admin.tasks.index.submit")
      if params[:indicators].nil?
        task_id = params[:task_id]
      else
        period_id =  params[:tasks][:period_id]
        organization_type_id = params[:tasks][:organization_type_id]
        main_process_id = params[:tasks][:main_process_id]
        sub_process_id = params[:tasks][:sub_process_id]
        task_id = params[:tasks][:task_id]
        indicator_id = params[:tasks][:indicator_id]
      end

      @indicators = Indicator.where("task_id = ?", task_id)
      @task = Task.find(task_id)
      @sub_process = SubProcess.find(@task.sub_process_id)
      @main_process = MainProcess.find(@sub_process.main_process_id)
      @period = Period.find(@main_process.period_id)
      @organization_type = OrganizationType.find(@period.organization_type_id)
    end
      @organization_types = OrganizationType.all
      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
      @main_processes = MainProcess.where("period_id = ?", @periods.first.id)
      @sub_processes = SubProcess.where("main_process_id = ?", @main_processes.first.id)
  end

  def update
    @indicator.assign_attributes(indicator_params)
    if @indicator.save
      redirect_to admin_indicators_path
    else
      render :edit
    end
  end

  private
    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order, :in_out,
                                 :metric, :total_sub_process, :total_process)
   end
   def set_indicator
      @indicator = Indicator.find(params[:id])
   end
end
