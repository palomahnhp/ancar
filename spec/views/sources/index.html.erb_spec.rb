require 'rails_helper'

RSpec.describe "sources/index", type: :view do
  before(:each) do
    assign(:sources, [
      Source.create!(),
      Source.create!()
    ])
  end

  it "renders a list of sources" do
    render
  end
end
