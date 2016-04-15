require 'rails_helper'

RSpec.describe "subtypeorgs/new", type: :view do
  before(:each) do
    assign(:subtypeorg, Subtypeorg.new())
  end

  it "renders new subtypeorg form" do
    render

    assert_select "form[action=?][method=?]", subtypeorgs_path, "post" do
    end
  end
end
