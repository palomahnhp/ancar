class Manager::IndicatorsController < Manager::BaseController

  before_action :set_indicator, only: [:show, :edit, :update, :destroy]
  before_action :initialize_instance_vars, only: [:index, :new, :edit, :create]

  def index
    @indicators = @task.indicators.order(:order)
  end

  def new
    @task = Task.find(params[:task_id])
    @indicator = Indicator.new
  end

  def edit
    @indicator  = Indicator.find(params[:id])
  end

  def create
    @indicator = Indicator.new(indicator_params)
    @indicator.item_id = desc_to_item_id(params[:item_desc], Indicator.name.underscore)
    @indicator.indicator_metrics.take.metric_id =
       desc_to_item_id(params[:metric_desc], Metric.name.underscore)
    @indicator.indicator_sources.take.source_id =
        desc_to_item_id(params[:source_desc], Source.name.underscore)
    update_total_indicators_summary_types

    if @indicator.save
      redirect_to_index(t("manager.indicators.create.success"))
    else
      render :new
    end
  end

  def update
    @indicator.assign_attributes(indicator_params)
    if @indicator.save
      puts 'Esto en update indicator'
      debugger
      redirect_to_index(t("manager.indicators.update.success"))
    else
      render :edit
    end
  end

  def destroy
     if @sub_process.destroy_all
       msg = t("manager.indicators.destroy.success")
     else
       msg = t("manager.indicators.destroy.error")
     end
     redirect_to_index(msg)
  end

  private
    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order, :in_out,
                                 :metric_id, :total_sub_process, :total_process)
    end

    def set_indicator
      @indicator = Indicator.find(params[:id])
    end

    def update_total_indicators_summary_types
      SummaryType.all.each do |summary_type|
        if params[summary_type.item.description.to_sym].nil?
          TotalIndicator.where(indicator_metric_id: @indicator.indicator_metrics.take.id,
          summary_type_id: summary_type.id).delete_all
        else
          TotalIndicator.where(indicator_metric_id: @indicator.indicator_metrics.take.id).find_or_create_by(summary_type_id: summary_type.id, indicator_type: summary_type.acronym)
        end
      end
    end

    def redirect_to_index(msg)
        redirect_to manager_indicators_path(commit: t("manager.indicators.index.submit"),
           task_id: @task.id,
           sub_process_id: @sub_process.id,
           main_process_id: @main_process.id,
           period_id: @period.id, organization_type_id: @period.organization_type_id,
           modifiable: @period.modifiable?, eliminable: @period.eliminable?),
           notice: msg
    end

    def initialize_instance_vars
      @items = items_map(Indicator.name.underscore)
      @metrics = items_map(Metric.name.underscore)
      @sources = items_map(Source.name.underscore)

      @task = Task.find(params[:task_id])
      @sub_process = @task.sub_process
      @main_process = @sub_process.main_process
      @period = @main_process.period
      @organization_type = @period.organization_type
      @unit_type = @sub_process.unit_type
      @item_summary_types = Item.where(item_type: "summary_type")

    end
end
