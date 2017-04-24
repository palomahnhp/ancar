class Supervisor::MainProcessesController < Supervisor::BaseController

  def index
    @period = Period.find(params[:period_id])
    @main_processes = @period.main_processes.order(:order)

    if params[:commit] == t('supervisor.main_processes.index.submit')
      if params[:main_processes].nil?
        period_id = params[:period_id]
          organization_type_id = params[:organization_type_id]
      else
        period_id =  params[:main_processes][:period_id]
          organization_type_id = params[:main_processes][:organization_type_id]
      end
    end
  end

  def show
  end

  def new
    @period = Period.find(params[:period_id])
    @main_process = @period.main_processes.new
  end

  def edit
    @main_process = MainProcess.find(params[:id])
    if params[:commit]
      @main_process.item_id = params[:item_id]
      @main_process.order = params[:order]
      if @main_process.save
        redirect_to_index(t('supervisor.main_processes.update.success'))
      else
        render :edit
      end
    end
  end

  def create
    @period = Period.find(main_process_params[:period_id])
    @main_process = @period.main_processes.new(main_process_params)

    @main_process.item = Item.find_or_create_by(item_type: 'main_process', description: params[:item_description]) unless params[:item_description].empty?

    if @main_process.save
      redirect_to_index(t('supervisor.main_processes.create.success'))
    else
      render :new
    end
  end

  def update
    if params[:commit]
      @main_process = MainProcess.find(params[:id])
      @main_process.assign_attributes(main_process_params)
      @main_process.item = Item.find_or_create_by(item_type: 'main_process', description: params[:item_description]) unless params[:item_description].empty?
      if @main_process.save
        redirect_to_index(t('supervisor.main_processes.update.success'))
      else
        render :edit
      end
    end
  end

  def destroy
   @main_process = MainProcess.find(params[:id])
   if @main_process.destroy
     msg = t('supervisor.main_processes.destroy.success')
   else
     msg = t('supervisor.main_processes.destroy.error')
   end
     redirect_to_index(msg)
  end

  private
    def main_process_params
      params.require(:main_process).permit(:period_id, :item_id, :order, :organization_id)
    end

    def redirect_to_index(msg)
      redirect_to supervisor_main_processes_path(commit: t('supervisor.main_processes.index.submit'),
           period_id: @main_process.period.id),
           notice: msg
    end
end
