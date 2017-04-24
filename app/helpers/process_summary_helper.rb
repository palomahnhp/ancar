module ProcessSummaryHelper
  def summary_indicators(id)
    # noinspection RailsChecklist05
    ps = SummaryProcess.find_by(process_type: @type, process_id: id)
    ps.summary_process_indicators.select(:indicator, :metric).distinct unless ps.nil?
  end

  def summary_details(id)
    # noinspection RailsChecklist05
    ps = SummaryProcess.find_by(process_type: @type, process_id: id)
    ps.summary_process_details.order(unit_id: :asc) unless ps.nil?
  end

  def distrito(id)
    # noinspection RailsChecklist05
    Organization.find(id).description
  end

  def stats(function, campo, spd)

   len = spd.count
   case function
   when 'total'
    spd.pluck(campo.to_sym).inject(:+)
   when 'sort'
    spd.pluck(campo.to_sym).sort
   when 'average'
    total = stats('total', campo, spd)
    number_with_precision(total.to_f / len, precision: 2)
   when 'median'
    sorted = stats('sort', campo, spd)
    number_with_precision(len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2, precision: 2)
   when 'coefficient'
    number_with_precision(stats('total', 'amount', spd) / stats('total', campo, spd), precision: 2)
   end
  end

private

end
