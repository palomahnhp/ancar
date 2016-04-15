require 'rails_helper'

RSpec.describe "unit_types/new", type: :view do
  before(:each) do
    assign(:unit_type, UnitType.new())
  end

  it "renders new unit_type form" do
    render

    assert_select "form[action=?][method=?]", unit_types_path, "post" do
    end
  end
end
