class Admin::EntryIndicatorsController < Admin::BaseController

  def index
    @entry_indicators = EntryIndicator.by_period_unit_and_source(params[:period_id], params[:unit_id], params[:source_id] )
  end

  def show
    @entry_indicator = EntryIndicator.find(params[:id])
  end

  def new
    @entry_indicator = EntryIndicator.new
  end

  def create
    @entry_indicator = EntryIndicator.new(params[:entry_indicator])
    if @entry_indicator.save
      flash[:notice] = "Creado entry indicator"
      redirect_to @entry_indicator
    else
      render :action => 'new'
    end
  end

  def edit
    @entry_indicator =  EntryIndicator.find(params[:id])
  end

  def update
    @entry_indicator =  EntryIndicator.find(params[:id])

    if @entry_indicator.updated_attributes(params[:entry_indicator])
      flash[:notice] = "Actualizado entry indicator"
      redirect_to @entry_indicator
    else
      render :action => 'edit'
    end
  end

  def destroy
    @entry_indicator =  EntryIndicator.find(params[:id])

    @entry_indicator.destroy
    flash[:notice] = "Eliminado entry indicator"
    redirect_to admin_entry_indicator_url
  end

  def edit_individual
    @entry_indicators =  EntryIndicator.find(params[:entry_indicators].keys)
  end

  def update_individual
    @entry_indicators = EntryIndicator.update(params[:entry_indicators].keys, params[:entry_indicators].values).reject { |ei| ei.errors.empty? }
    if @entry_indicators.empty?
      flash[:notice] = "Actualizados entry indicators"
      redirect_to admin_entry_indicators_path
    else
      render action: 'edit_individual'
    end
  end

  def search
    source = []
    if params[:source_id].present?
      source = Item.find(params[:source_id]).sources.take.id
    else
      source = Source.fixed.ids
    end
#    period = Period.where(organization_type: Unit.find(params[:unit_id]).organization.organization_type).order(:id).last
    redirect_to admin_entry_indicators_path(period_id: params[:period_id], unit_id: params[:unit_id], source_id: source)
  end
end
