module DateHelper
  def format_date(d, format = :default)
    return d unless d.is_a? Date
    I18n.localize(d, format: format.to_sym)
  end

  def iso_date(d)
    return d unless d
    d.strftime("%Y-%m-%d")
  end

  def parse_date(date)
    date
  end
end
