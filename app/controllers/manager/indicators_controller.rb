class Manager::IndicatorsController < Manager::BaseController
  include ManagerActions
#   load_and_authorize_resource
  before_action :set_indicator, only: [:show, :edit, :update, :destroy]

  def index
    task_id = params[:task_id]
    @task = Task.find(task_id)
    @indicators = @task.indicators.order(:order)
    @sub_process = @task.sub_process
    @unit_type = @sub_process.unit_type
    @main_process = @sub_process.main_process
    @period = @main_process.period
    @organization_type = @period.organization_type
    @summary_types = Item.where(item_type: "summary_type")
  if params[:commit] == t("manager.tasks.index.submit")
    end
  end

  def edit

    @indicator  = Indicator.find(params[:id])
    @task       = @indicator.task
    @sub_process  = @task.sub_process
    @unit_type    = @sub_process.unit_type #UnitType.find(@sub_process.unit_type_id)
    @main_process = @sub_process.main_process #MainProcess.find(@sub_process.main_process_id)
    @period       = @main_process.period
    @organization_type = OrganizationType.find(@unit_type.organization_type_id)
    debugger
    @items    = select_option_descriptions(Indicator.name.underscore)
    @metrics  = select_option_descriptions(Metric.name.underscore)
    @sources  = select_option_descriptions(Source.name.underscore)

    @items_summary_types = Item.where(item_type: "summary_type")

    if params[:commit]
      @indicator.item_id =
        desc_to_item_id(params[:item_desc], Indicator.name.underscore)
      @indicator.order = params[:order]
      @indicator.indicator_metrics.take.metric_id =
        desc_to_item_id(params[:metric_desc], Metric.name.underscore)
      @indicator.indicator_sources.take.source_id =
        desc_to_item_id(params[:source_desc], Source.name.underscore)
      if @indicator.save
        redirect_to manager_indicator_path(commit: t("manager.indicators.index.submit"),
           task_id: @task.id,
           sub_process_id: @sub_process.id,
           main_process_id: @main_process.id,
           period_id: @period.id, organization_type_id: @period.organization_type_id)
      else
        render :edit
      end
    end
  end

  def update
    @indicator.assign_attributes(indicator_params)
    if @indicator.save
      redirect_to manager_indicators_path
    else
      render :edit
    end
  end

  def destroy
     if @sub_process.destroy_all
       msg = t("manager.sub_processes.index.destroy.success")
     else
       msg = t("manager.sub_processes.index.destroy.error")
     end
     redirect_to manager_sub_processes_path, notice: msg
  end

  private

    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order, :in_out,
                                 :metric_id, :total_sub_process, :total_process)
    end

    def set_indicator
      @indicator = Indicator.find(params[:id])
    end

end
