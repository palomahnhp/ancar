require 'rails_helper'

RSpec.describe "procesos/index", type: :view do
  before(:each) do
    assign(:procesos, [
      Proceso.create!(),
      Proceso.create!()
    ])
  end

  it "renders a list of procesos" do
    render
  end
end
