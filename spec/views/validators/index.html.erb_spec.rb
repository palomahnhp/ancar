require 'rails_helper'

RSpec.describe "validators/index", type: :view do
  before(:each) do
    assign(:validators, [
      Validator.create!(),
      Validator.create!()
    ])
  end

  it "renders a list of validators" do
    render
  end
end
