require 'rails_helper'

RSpec.describe "subtypeorgs/index", type: :view do
  before(:each) do
    assign(:subtypeorgs, [
      Subtypeorg.create!(),
      Subtypeorg.create!()
    ])
  end

  it "renders a list of subtypeorgs" do
    render
  end
end
