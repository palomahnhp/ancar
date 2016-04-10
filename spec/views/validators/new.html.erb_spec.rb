require 'rails_helper'

RSpec.describe "validators/new", type: :view do
  before(:each) do
    assign(:validator, Validator.new())
  end

  it "renders new validator form" do
    render

    assert_select "form[action=?][method=?]", validators_path, "post" do
    end
  end
end
