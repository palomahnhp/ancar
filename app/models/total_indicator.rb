class TotalIndicator < ActiveRecord::Base
  belongs_to :indicator_metric
  belongs_to :indicator_group
  belongs_to :summary_type

  def copy(indicator_metric_id)
    TotalIndicator.create(self.attributes.merge(id: nil, indicator_metric_id: indicator_metric_id))
  end

end
