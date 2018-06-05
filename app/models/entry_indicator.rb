class EntryIndicator < ActiveRecord::Base
  resourcify

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user },
          :params => {
              :id => :id,
              :description => proc {|controller, model_instance| model_instance.indicator_metric.indicator.item.description},
              :amount =>  proc {|controller, model_instance| model_instance.amount.to_s},
              :imported_amount =>  proc {|controller, model_instance| model_instance.imported_amount.to_s},

          }

#  has_many :entry_indicator_sources

  has_many :metrics, through: :indicator_metrics
  has_many :indicators, through: :indicator_metrics
#  has_many :sources, through: :entry_indicator_sources

  belongs_to :indicator_metric
  belongs_to :indicator_source
  belongs_to :unit, inverse_of: :entry_indicators

  validates_presence_of :unit

  validates_associated :indicator_metric
  validates_associated :indicator_source

  validates_numericality_of :amount


  scope :period, ->(id) { where(period_id: id) }

  def amount=(val)
    val.sub!(',', '.') if val.is_a?(String)
    self['amount'] = val
  end

  def self.delete_by_indicator_metric(unit_id, indicator_metric_id)
    self.where(unit_id: unit_id, indicator_metric_id: indicator_metric_id).delete_all
  end

  def self.by_period_unit_and_source(period, unit, source)
    entry_indicators = where(period_id: period, unit_id: unit)
    ei = entry_indicators.map{ |ei| ei if ei.source?(source) }
    return ei
  end

  def self.create_from_import(data)
    entry_indicator = EntryIndicator.find_or_create_by(unit_id: data["unit_id"], indicator_metric_id: data["indicator_metric"], period_id: data["period_id"] )
    entry_indicator.amount =  data["amount"]
    entry_indicator.imported_amount =  data["imported_amount"]
    entry_indicator.updated_by =  data["updated_by"]

    entry_indicator
  end

  def source?(source)
     source.include?(self.indicator_metric.indicator_sources.take.source.id.to_s)
  end

end
