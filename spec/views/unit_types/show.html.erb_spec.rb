require 'rails_helper'

RSpec.describe "unit_types/show", type: :view do
  before(:each) do
    @unit_type = assign(:unit_type, UnitType.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
