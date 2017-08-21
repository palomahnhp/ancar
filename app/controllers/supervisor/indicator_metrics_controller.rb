class Supervisor::IndicatorMetricsController < Supervisor::BaseController
  before_action :set_indicator_metric, only: [:edit, :update, :add_empty_source, :destroy, :destroy_source]

  def new
    @indicator = Indicator.find(params[:indicator_id])
    @indicator_metric = @indicator.indicator_metrics.new
  end

  def edit

  end

  def create
    @indicator = Indicator.find(params[:indicator_id])
    @indicator_metric = @indicator.indicator_metrics.new
    @indicator_metric.assign_attributes(indicator_metric_params)
    if @indicator_metric.save
      update_summary_types
      redirect_to_index(t('supervisor.indicator_metrics.create.success'))
    else
      render render_to
    end
  end

  def update
    @indicator_metric.assign_attributes(indicator_metric_params)
    if @indicator_metric.save
      update_summary_types
      redirect_to_index(t('supervisor.indicator_metrics.create.success'))
    else
      render render_to
    end
  end

  def add_empty_source
    IndicatorSource.create!(indicator_metric: @indicator_metric, source: Source.find_or_create_by!(item: Item.find_or_create_by!(item_type: 'source', description: '')))
    render :edit
  end

  def destroy_source
    source = Source.find(params[:source])
    IndicatorSource.delete_all(indicator_metric: @indicator_metric, source: source)
    render :edit
  end

  def destroy
    if @indicator_metric.destroy
      msg = t('supervisor.indicators_metrics.destroy.success')
    else
      msg = t('supervisor.indicators_metrics.destroy.error')
    end
    redirect_to_index(msg)
  end

  private
  def indicator_metric_params
    params.require(:indicator_metric).permit(:indicator_id, :metric_id, :order,
                              indicator_sources_attributes: [:id, :source_id, :_destroy])
  end

  def update_summary_types
    SummaryType.all.each do |summary_type|
      if params[summary_type.item.description].nil? || params[summary_type.item.description].empty?
        summary_type.total_indicators.find_by_indicator_metric_id(@indicator_metric.id).delete unless summary_type.total_indicators.find_by_indicator_metric_id(@indicator_metric.id).nil?
      else
        tit = TotalIndicatorType.find(params[summary_type.item.description]).acronym
        ti = summary_type.total_indicators.find_or_create_by(indicator_metric_id: @indicator_metric.id,
                                                             indicator_type: summary_type.acronym)
        ti.in_out =  tit
        ti.updated_by = current_user.login
        ti.save
      end
    end
  end

  def redirect_to_index(msg)
    redirect_to supervisor_indicators_path(commit: t('supervisor.indicator_metrics.index.submit'),
                                        sub_process_id: @indicator.sub_process.id,
                                        indicator_id: @indicator.id), notice: msg
  end

    def set_indicator_metric
      @indicator_metric  = IndicatorMetric.find(params[:id])
      @indicator = @indicator_metric.indicator
    end
end
