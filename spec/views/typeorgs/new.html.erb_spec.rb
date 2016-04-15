require 'rails_helper'

RSpec.describe "typeorgs/new", type: :view do
  before(:each) do
    assign(:typeorg, Typeorg.new())
  end

  it "renders new typeorg form" do
    render

    assert_select "form[action=?][method=?]", typeorgs_path, "post" do
    end
  end
end
