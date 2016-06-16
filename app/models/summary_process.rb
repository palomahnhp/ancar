class SummaryProcess < ActiveRecord::Base
    belongs_to :process, polymorphic: true

    validates_inclusion_of :process_type, in: ["Unit", "MainProcess", "SubProcess"]
end
