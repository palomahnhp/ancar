require 'rails_helper'

RSpec.describe "validadors/show", type: :view do
  before(:each) do
    @validador = assign(:validador, Validador.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
