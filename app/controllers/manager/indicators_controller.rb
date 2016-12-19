class Manager::IndicatorsController < Manager::BaseController

  before_action :initialize_instance_vars, only: [:index, :edit, :update, :create, :destroy]

  def index
    @indicators = @task.indicators.order(:order).includes(:item, :entry_indicators,
      :indicator_metrics, :metrics, :entry_indicators, :total_indicators, :summary_types,
                                                          :indicator_sources, sources: :item)
  end

  def new
    @sub_process = SubProcess.find(params[:sub_process_id])
    @task = @sub_process.tasks.take
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
    @indicator.order = @indicator.order.to_s.rjust(2, '0')  # => '05'

    if !metric_id.nil? && !source_id.nil? && @indicator.save
      params[:indicator_metric_id] = @indicator.indicator_metrics.create(metric_id: metric_id).id
      @indicator.indicator_sources.create(source_id: source_id)

      update_total_indicators_summary_types
      redirect_to_index(t('manager.indicators.create.success'))
    else
      if metric_id.nil? || source_id.nil?
         @indicator.valid?
      end

      if metric_id.nil?
        @indicator.errors[:metric_id] = t('manager.errors.models.indicator.attributes.metric_id.blank')
      end
      if source_id.nil?
        @indicator.errors[:source_id] = t('manager.errors.models.indicator.attributes.source_id.blank')
      end
      render :new
    end
  end

  def update
    @indicator  = Indicator.find(params[:id])
    @indicator.assign_attributes(indicator_params)

    indicator_item_id = desc_to_item_id(params[:item_desc], Indicator.name.underscore)
    @indicator.item_id = indicator_item_id if @indicator.item_id != indicator_item_id
    @indicator.order = @indicator.order.to_s.rjust(2, '0')  # => '05'

    metric_id = desc_to_metric_id(params[:metric_desc], Metric.name.underscore)
    @indicator_metric = params[:indicator_metrics]
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
      redirect_to_index(t('manager.indicators.update.success'))
    else
      render :edit
    end
  end

  def destroy
     @indicator  = Indicator.find(params[:id])
     @task = @indicator.task
     if @indicator.destroy
       msg = t('manager.indicators.destroy.success')
     else
       msg = t('manager.indicators.destroy.error')
     end
     redirect_to_index(msg)
  end

  private
    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order)
    end

    def update_total_indicators_summary_types
      @summary_types.each do |summary_type|
        if params[summary_type.item.description].nil? || params[summary_type.item.description].empty?
          summary_type.total_indicators.find_by_indicator_metric_id(params[:indicator_metric_id]).delete
        else
          # Si es númerico es el id #new
          if params[summary_type.item.description.to_sym].to_i.to_s == params[summary_type.item.description.to_sym]
            tit = TotalIndicatorType.find(params[summary_type.item.description.to_sym]).acronym
          else
            # si es cadena es item.description #edit
            tit = TotalIndicatorType.find(@total_indicator_types.to_h[params[summary_type.item.description.to_sym]]).acronym
          end
          ti = summary_type.total_indicators.find_or_create_by(indicator_metric_id: params[:indicator_metric_id],
            indicator_type: summary_type.acronym)
          ti.in_out =  tit
          ti.updated_by = current_user.login
          ti.save
        end
      end
    end

    def redirect_to_index(msg)
      redirect_to manager_indicators_path(commit: t('manager.indicators.index.submit'),
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

      if params[:sub_process_id]
        @task = SubProcess.find(params[:sub_process_id]).tasks.take
      elsif params[:task_id]
        @task = Task.find(params[:task_id])
      elsif indicator_params[:task_id]
        @task = Task.find(indicator_params[:task_id])
      end

      @sub_process = @task.sub_process
      @main_process = @sub_process.main_process
      @period = @main_process.period
      @organization_type = @period.organization_type
      @unit_type = @sub_process.unit_type
      @summary_types = SummaryType.active.includes(:total_indicators, :item)
      @item_summary_types = @summary_types.map {|st| st.item}
      @total_indicator_types = TotalIndicatorType.active.order(:order).includes(:item).map{ |type| [type.item.description, type.id] }
    end

end
