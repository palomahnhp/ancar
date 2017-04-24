class Supervisor::IndicatorsController < Supervisor::BaseController

  def index
    @sub_process = SubProcess.find(params[:sub_process_id])
    @indicators = @sub_process.tasks.take.indicators.order(:order).includes(:item,
      :indicator_metrics, :metrics, :total_indicators, :summary_types, :indicator_sources, sources: :item)
  end

  def new
    @sub_process = SubProcess.find(params[:sub_process_id])
    @task = @sub_process.tasks.take
    @indicator = Indicator.new
    @indicator.task = @task
  end

  def edit
    @indicator  = Indicator.find(params[:id])
  end

  def create
    @indicator = Indicator.new(indicator_params)
    @indicator.item = Item.find_or_create_by(item_type: 'indicator', description: params[:item_description]) unless params[:item_description].empty?
    @sub_process = @indicator.sub_process
    if @indicator.save
      redirect_to_index(t('supervisor.indicators.create.success'))
    else
      render :new
    end
  end

  def update
    @indicator  = Indicator.find(params[:id])
    @indicator.assign_attributes(indicator_params)
    @indicator.item = Item.find_or_create_by(item_type: 'indicator', description: params[:item_description]) unless params[:item_description].empty?
    @sub_process = @indicator.sub_process
    if @indicator.save
      redirect_to_index(t('supervisor.indicators.update.success'))
    else
      render :edit
    end
  end

  def destroy
     @indicator  = Indicator.find(params[:id])
     @sub_process = @indicator.sub_process
     @task = @indicator.task
     if @indicator.destroy
       msg = t('supervisor.indicators.destroy.success')
     else
       msg = t('supervisor.indicators.destroy.error')
     end
     redirect_to_index(msg)
  end

  private
    def indicator_params
      params.require(:indicator).permit(:task_id, :item_id, :order)
    end

    def redirect_to_index(msg)
      redirect_to supervisor_indicators_path(commit: t('supervisor.indicators.index.submit'),
           sub_process_id: @sub_process.id),
           notice: msg
    end

end
