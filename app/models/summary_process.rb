class SummaryProcess < ActiveRecord::Base
    belongs_to :process, polymorphic: true
    validates_inclusion_of :process_type, in: ["Unit", "MainProcess", "SubProcess"]
    has_many :summary_process_indicators, dependent: :destroy
    has_many :summary_process_details, dependent: :destroy
end
