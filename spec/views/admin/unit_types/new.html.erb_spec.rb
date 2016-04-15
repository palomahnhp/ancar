require 'rails_helper'

RSpec.describe "admin/unit_types/new", type: :view do
  before(:each) do
    assign(:admin_unit_type, Admin::UnitType.new())
  end

  it "renders new admin_unit_type form" do
    render

    assert_select "form[action=?][method=?]", admin_unit_types_path, "post" do
    end
  end
end
