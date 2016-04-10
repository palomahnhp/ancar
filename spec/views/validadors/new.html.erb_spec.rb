require 'rails_helper'

RSpec.describe "validadors/new", type: :view do
  before(:each) do
    assign(:validador, Validador.new())
  end

  it "renders new validador form" do
    render

    assert_select "form[action=?][method=?]", validadors_path, "post" do
    end
  end
end
