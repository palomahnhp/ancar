require 'rails_helper'

RSpec.describe "admin/unit_types/show", type: :view do
  before(:each) do
    @admin_unit_type = assign(:admin_unit_type, Admin::UnitType.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
