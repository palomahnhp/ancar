require 'rails_helper'

RSpec.describe "subtypeorgs/edit", type: :view do
  before(:each) do
    @subtypeorg = assign(:subtypeorg, Subtypeorg.create!())
  end

  it "renders the edit subtypeorg form" do
    render

    assert_select "form[action=?][method=?]", subtypeorg_path(@subtypeorg), "post" do
    end
  end
end
