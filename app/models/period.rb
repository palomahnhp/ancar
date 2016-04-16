class Period < ActiveRecord::Base
  has_many :main_process
  belongs_to :organization_type

  validates :name, presence: true
  validates :description, presence: true
  validates :open_at, presence: true
  validates :close_at, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  def is_open?
    open_at <=  DateTime.now  && close_at >=  DateTime.now
  end
end
