class DocsController < ApplicationController

  def index
    @docs = Doc.all
  end

end
