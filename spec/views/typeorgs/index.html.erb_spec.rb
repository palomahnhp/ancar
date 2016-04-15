require 'rails_helper'

RSpec.describe "typeorgs/index", type: :view do
  before(:each) do
    assign(:typeorgs, [
      Typeorg.create!(),
      Typeorg.create!()
    ])
  end

  it "renders a list of typeorgs" do
    render
  end
end
