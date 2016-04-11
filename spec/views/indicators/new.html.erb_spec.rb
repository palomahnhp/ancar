require 'rails_helper'

RSpec.describe "indicators/new", type: :view do
  before(:each) do
    assign(:indicator, Indicator.new())
  end

  it "renders new indicator form" do
    render

    assert_select "form[action=?][method=?]", indicators_path, "post" do
    end
  end
end
