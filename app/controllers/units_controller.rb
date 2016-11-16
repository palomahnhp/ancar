class UnitsController < ApplicationController

  def index
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

    def unit_params
      params.require(:unit).permit(:description_sap, :unit_type_id, :organization_id, :sap_id, :order,
         entry_indicators_attributes: [:id, :amount, :indicator_metric_id, :indicator_source_id])
    end

end
