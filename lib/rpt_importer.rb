class RptImporter
  attr_reader :filepath
  before_perform :notify_admin(:before)
  after_perform :notify_admin(:after)

  def initialize(year, extname, filepath)
    @year     = year
    @filepath = filepath
    @year     = year
  end

  def run
    puts Time.zone.now.to_s + " - Prepare to import #{filepath} ..."
    # some crunching code
    puts  Time.zone.now.to_s + " - Import #{filepath} completed"
  end

  private

  def notify_admin(param)
    if param == :after
      puts '*** After perform Ejecutado importer '
    else
      puts '*** Before perform Ejecutado importer '
    end
  end
end
