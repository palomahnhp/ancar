require 'rails_helper'

RSpec.describe "typeorgs/edit", type: :view do
  before(:each) do
    @typeorg = assign(:typeorg, Typeorg.create!())
  end

  it "renders the edit typeorg form" do
    render

    assert_select "form[action=?][method=?]", typeorg_path(@typeorg), "post" do
    end
  end
end
