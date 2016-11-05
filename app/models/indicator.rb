class Indicator < ActiveRecord::Base
  has_many :indicator_sources, :dependent => :destroy
  has_many :indicator_metrics, :dependent => :destroy

  has_many :metrics, through: :indicator_metrics
  has_many :entry_indicators, through: :indicator_metrics
  has_many :sources, through: :indicator_sources

  belongs_to :task
  belongs_to :item, -> { where item_type: "indicator" }


  def copy(tk_id, current_user_login)
    i = Indicator.create(self.attributes.merge(id: nil, task_id: tk_id, updated_by: current_user_login))
    indicator_sources.each do |is|
      is.copy(i.id)
    end
    indicator_metrics.each do |im|
      im.copy(i.id)
    end
  end

  def is_empty?
    true
  end

end
