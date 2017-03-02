class TotalIndicator < ActiveRecord::Base
  belongs_to :indicator_metric
  belongs_to :indicator_group
  belongs_to :summary_type

  scope :type_in, -> { where(in_out: 'E') }
  scope :type_out, -> { where(in_out: 'S') }
  scope :for_process, -> { where(summary_type_id: SummaryType.process) }
  scope :for_sub_process, -> { where(summary_type_id: SummaryType.sub_process) }
  scope :for_stock, -> { where(summary_type_id: SummaryType.stock) }

  def copy(indicator_metric_id)
    TotalIndicator.create(self.attributes.merge(id: nil, indicator_metric_id: indicator_metric_id))
  end

end
