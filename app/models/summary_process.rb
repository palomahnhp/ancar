class SummaryProcess < ActiveRecord::Base
    belongs_to :process, polymorphic: true

    has_many :summary_process_indicators, dependent: :destroy
    has_many :summary_process_details, dependent: :destroy

    validates_inclusion_of :process_type, in: ["Unit", "MainProcess", "SubProcess"]
end
