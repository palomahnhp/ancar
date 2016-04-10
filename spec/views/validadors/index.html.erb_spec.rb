require 'rails_helper'

RSpec.describe "validadors/index", type: :view do
  before(:each) do
    assign(:validadors, [
      Validador.create!(),
      Validador.create!()
    ])
  end

  it "renders a list of validadors" do
    render
  end
end
