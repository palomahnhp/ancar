class Manager::IndicatorMetricsController < Manager::BaseController

  def new
    @indicator = Indicator.find(params[:indicator_id])
    @indicator_metric = @indicator.indicator_metrics.new
  end

  def edit
    @indicator_metric  = IndicatorMetric.find(params[:id])
  end

  def create
    @indicator = Indicator.find(params[:indicator_id])
    @indicator_metric = @indicator.indicator_metrics.new(indicator_metric_params)

    if !params[:source_id].empty? && @indicator_metric.save
      @indicator_metric.indicator_sources.destroy_all
      @indicator_source = @indicator_metric.indicator_sources.find_or_create_by!(source_id: params[:source_id])
      @indicator_source.indicator_id =  @indicator.id
      update_total_indicators_summary_types
      redirect_to_index(t('manager.indicator_metrics.create.success'))
    else
      if params[:source_id].nil? || params[:source_id].empty?
        @indicator_metric.valid?
        @indicator_metric.errors[:source_id] =
            t('activerecord.errors.models.indicator_metric.attributes.source_id.blank')
      end
      render :new
    end
  end

  def update
    @indicator = Indicator.find(params[:indicator_id])

    @indicator_metric  = IndicatorMetric.find(params[:id])
    @indicator_metric.assign_attributes(indicator_metric_params)

    if !params[:source_id].empty? && @indicator_metric.save
      @indicator_metric.indicator_sources.destroy_all
      @indicator_source = @indicator_metric.indicator_sources.find_or_create_by!(source_id: params[:source_id])
      @indicator_source.indicator_id =  @indicator.id
      update_total_indicators_summary_types
      redirect_to_index(t('manager.indicator_metrics.update.success'))
    else
      if params[:source_id].nil? || params[:source_id].empty?
        @indicator_metric.valid?
        @indicator_metric.errors[:source_id] =
            t('activerecord.errors.models.indicator_metric.attributes.source_id.blank')
      end
      render :edit
    end
    update_total_indicators_summary_types
  end

  def destroy
    @indicator = Indicator.find(params[:indicator_id])

    @indicator_metric  = IndicatorMetric.find(params[:id])
    if @indicator_metric.destroy
      msg = t('manager.indicators_metrics.destroy.success')
    else
      msg = t('manager.indicators_metrics.destroy.error')
    end
    redirect_to_index(msg)
  end

  private
  def indicator_metric_params
    params.require(:indicator_metric).permit(:indicator_id, :metric_id, :order)
  end

  def update_total_indicators_summary_types
    SummaryType.all.each do |summary_type|
      if params[summary_type.item.description].nil? || params[summary_type.item.description].empty?
        summary_type.total_indicators.find_by_indicator_metric_id(@indicator_metric.id).delete unless summary_type.total_indicators.find_by_indicator_metric_id(@indicator_metric.id).nil?
      else
        # Si es númerico es el id #new
        if params[summary_type.item.description] == params[summary_type.item.description]
          tit = TotalIndicatorType.find(params[summary_type.item.description]).acronym
        else
          # si es cadena es item.description #edit
          tit = TotalIndicatorType.find(@total_indicator_types.to_h[params[summary_type.item.description.to_sym]]).acronym
        end
        ti = summary_type.total_indicators.find_or_create_by(indicator_metric_id: @indicator_metric.id,
                                                             indicator_type: summary_type.acronym)
        ti.in_out =  tit
        ti.updated_by = current_user.login
        ti.save
      end
    end
  end

  def redirect_to_index(msg)
    redirect_to manager_indicators_path(commit: t('manager.indicator_metrics.index.submit'),
                                        sub_process_id: @indicator.sub_process.id,
                                        indicator_id: @indicator.id), notice: msg
  end


end
