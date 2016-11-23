class Manager::IndicatorsController < Manager::BaseController

  before_action :initialize_instance_vars, only: [:index, :edit, :update, :create, :destroy]

  def index
    @indicators = @task.indicators.order(:order)
  end

  def new
    @task = Task.find(params[:task_id])
    @indicator = Indicator.new
    @indicator.task = @task
    initialize_instance_vars
  end

  def edit
    @indicator  = Indicator.find(params[:id])
  end

  def create
    @indicator = Indicator.new(indicator_params)
    @indicator.task = @task

    indicator_item_id = desc_to_item_id(params[:item_desc], Indicator.name.underscore)
    @indicator.item_id = indicator_item_id if @indicator.item_id != indicator_item_id

    metric_id = desc_to_metric_id(params[:metric_desc], Metric.name.underscore)
    source_id = desc_to_source_id(params[:source_desc], Source.name.underscore)

    if !metric_id.nil? && !source_id.nil? && @indicator.save
      @indicator.indicator_metrics.create(metric_id: metric_id)
      @indicator.indicator_sources.create(source_id: source_id)

      update_total_indicators_summary_types

      redirect_to_index(t("manager.indicators.create.success"))
    else
      if metric_id.nil? || source_id.nil?
         @indicator.valid?
      end

      if metric_id.nil?
        @indicator.errors[:metric_id] = t("manager.errors.models.indicator.attributes.metric_id.blank")
      end
      if source_id.nil?
        @indicator.errors[:source_id] = t("manager.errors.models.indicator.attributes.source_id.blank")
      end
      params
      render :new
    end
  end

  def update
    @indicator  = Indicator.find(params[:id])
    @indicator.assign_attributes(indicator_params)

    indicator_item_id = desc_to_item_id(params[:item_desc], Indicator.name.underscore)
    @indicator.item_id = indicator_item_id if @indicator.item_id != indicator_item_id

    metric_id = desc_to_metric_id(params[:metric_desc], Metric.name.underscore)
    @indicator_metric =  @indicator.indicator_metrics.take
    if @indicator_metric
      @indicator_metric.metric_id = metric_id if !metric_id.nil? || @indicator_metric.metric_id != metric_id
    end

    source_id = desc_to_source_id(params[:source_desc], Source.name.underscore)
    @indicator_source = @indicator.indicator_sources.take
    if @indicator_source
      @indicator_source.source_id = source_id if !source_id.nil? || @indicator_source.source_id != source_id
    end
    update_total_indicators_summary_types

    if (!@indicator_metric || @indicator_metric.save) && (!@indicator_source || @indicator_source.save) && @indicator.save
      redirect_to_index(t("manager.indicators.update.success"))
    else
      render :edit
    end
  end

  def destroy
     @indicator  = Indicator.find(params[:id])
     @task = @indicator.task
     if @indicator.destroy
       msg = t("manager.indicators.destroy.success")
     else
       msg = t("manager.indicators.destroy.error")
     end
     redirect_to_index(msg)
  end

  private
    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order)
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

      if params[:action] == "create" || params[:action] == "update"
        @task = Task.find(indicator_params[:task_id])
      else
        @task = Task.find(params[:task_id])
      end

      @sub_process = @task.sub_process
      @main_process = @sub_process.main_process
      @period = @main_process.period
      @organization_type = @period.organization_type
      @unit_type = @sub_process.unit_type
      @item_summary_types = SummaryType.active.map {|st| st.item}
    end
end
