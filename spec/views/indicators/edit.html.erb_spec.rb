require 'rails_helper'

RSpec.describe "indicators/edit", type: :view do
  before(:each) do
    @indicator = assign(:indicator, Indicator.create!())
  end

  it "renders the edit indicator form" do
    render

    assert_select "form[action=?][method=?]", indicator_path(@indicator), "post" do
    end
  end
end
