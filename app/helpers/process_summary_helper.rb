module ProcessSummaryHelper
  def summary_indicators(id)
    sp = SummaryProcess.find_by(process_id: id)
    sp.summary_process_indicators.select(:indicator, :metric).distinct if !sp.nil?
  end

  def summary_details(id)
    sp = SummaryProcess.find_by(process_id: id)
    sp.summary_process_details.order(unit_id: :asc) if !sp.nil?
  end

  def distrito(id)
    Organization.find(id).description
  end

end
