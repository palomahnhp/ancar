require 'rails_helper'

RSpec.describe "validadors/edit", type: :view do
  before(:each) do
    @validador = assign(:validador, Validador.create!())
  end

  it "renders the edit validador form" do
    render

    assert_select "form[action=?][method=?]", validador_path(@validador), "post" do
    end
  end
end
