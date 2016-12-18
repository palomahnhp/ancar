class SummaryProcess < ActiveRecord::Base
  resourcify

  belongs_to :main_process, polymorphic: true

  has_many :summary_process_indicators, dependent: :destroy
  has_many :summary_process_details, dependent: :destroy

  validates_inclusion_of :process_type, in: %w( Unit MainProcess SubProcess )

end
