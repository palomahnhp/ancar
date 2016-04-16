require 'rails_helper'

RSpec.describe "admin/units/edit", type: :view do
  before(:each) do
    @admin_unit = assign(:admin_unit, Admin::Unit.create!())
  end

  it "renders the edit admin_unit form" do
    render

    assert_select "form[action=?][method=?]", admin_unit_path(@admin_unit), "post" do
    end
  end
end
