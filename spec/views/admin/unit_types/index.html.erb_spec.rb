require 'rails_helper'

RSpec.describe "admin/unit_types/index", type: :view do
  before(:each) do
    assign(:admin_unit_types, [
      Admin::UnitType.create!(),
      Admin::UnitType.create!()
    ])
  end

  it "renders a list of admin/unit_types" do
    render
  end
end
