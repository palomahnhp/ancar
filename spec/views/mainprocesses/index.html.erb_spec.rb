require 'rails_helper'

RSpec.describe "mainprocesses/index", type: :view do
  before(:each) do
    assign(:mainprocesses, [
      Mainprocess.create!(),
      Mainprocess.create!()
    ])
  end

  it "renders a list of mainprocesses" do
    render
  end
end
