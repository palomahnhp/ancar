class Admin::LogsController < Admin::BaseController

  def index

  end

  def show_file
    file = params[:filepath]
    File.open( file, "r" )
    send_file( file )
  end

end
