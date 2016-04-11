require 'rails_helper'

RSpec.describe "sources/show", type: :view do
  before(:each) do
    @source = assign(:source, Source.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
