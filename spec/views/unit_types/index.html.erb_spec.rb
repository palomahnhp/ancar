require 'rails_helper'

RSpec.describe "unit_types/index", type: :view do
  before(:each) do
    assign(:unit_types, [
      UnitType.create!(),
      UnitType.create!()
    ])
  end

  it "renders a list of unit_types" do
    render
  end
end
