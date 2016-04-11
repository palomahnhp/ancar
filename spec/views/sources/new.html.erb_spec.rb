require 'rails_helper'

RSpec.describe "sources/new", type: :view do
  before(:each) do
    assign(:source, Source.new())
  end

  it "renders new source form" do
    render

    assert_select "form[action=?][method=?]", sources_path, "post" do
    end
  end
end
