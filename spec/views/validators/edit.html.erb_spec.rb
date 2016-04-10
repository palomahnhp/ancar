require 'rails_helper'

RSpec.describe "validators/edit", type: :view do
  before(:each) do
    @validator = assign(:validator, Validator.create!())
  end

  it "renders the edit validator form" do
    render

    assert_select "form[action=?][method=?]", validator_path(@validator), "post" do
    end
  end
end
