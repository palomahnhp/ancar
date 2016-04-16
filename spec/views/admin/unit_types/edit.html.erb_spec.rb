require 'rails_helper'

RSpec.describe "admin/unit_types/edit", type: :view do
  before(:each) do
    @admin_unit_type = assign(:admin_unit_type, Admin::UnitType.create!())
  end

  it "renders the edit admin_unit_type form" do
    render

    assert_select "form[action=?][method=?]", admin_unit_type_path(@admin_unit_type), "post" do
    end
  end
end
