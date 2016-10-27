class Manager::IndicatorsController < Manager::BaseController
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
    @indicator_types = Item.where(item_type: "indicator_type")
  if params[:commit] == t("manager.tasks.index.submit")
    end
  end


  def edit
    @items = Item.where(item_type: self.class.name.underscore).order(:description).map{|item| [item.description, item.id]}
    @indicator  = Indicator.find(params[:id])
    @task       = @indicator.task
    @sub_process  = @task.sub_process
    @unit_type    = @sub_process.unit_type #UnitType.find(@sub_process.unit_type_id)
    @main_process = @sub_process.main_process #MainProcess.find(@sub_process.main_process_id)
    @period       = @main_process.period
    @organization_type = OrganizationType.find(@unit_type.organization_type_id)
    @metrics   = Item.where(item_type: Metric.class.name.underscore).order(:description).map{|item| [item.description, item.id]}
    @sources   = Source.all.order(:description)
    if params[:commit]
      @sub_process.item_id =
        @items.to_h[params[:item_desc]].nil? ? item_new(params[:item_desc]) : @items.to_h[params[:item_desc]]
      @sub_process.order = params[:order]
      if @sub_process.save
        redirect_to manager_sub_processes_path(commit: t("manager.sub_processes.index.submit"),
           main_process_id: @sub_process.main_process_id,
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
    def unit_types
      @unit_types = UnitType.all.map { |type| [type.description, type.id] }
    end

    def item_new(description)
      Item.create(item_type: MainProcess.class.name.undescore, description: description).id
    end

    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order, :in_out,
                                 :metric_id, :total_sub_process, :total_process)
    end
    def set_indicator
      @indicator = Indicator.find(params[:id])
    end
end
