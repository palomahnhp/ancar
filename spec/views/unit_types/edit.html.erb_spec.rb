require 'rails_helper'

RSpec.describe "unit_types/edit", type: :view do
  before(:each) do
    @unit_type = assign(:unit_type, UnitType.create!())
  end

  it "renders the edit unit_type form" do
    render

    assert_select "form[action=?][method=?]", unit_type_path(@unit_type), "post" do
    end
  end
end
