require 'rails_helper'

RSpec.describe "procesos/new", type: :view do
  before(:each) do
    assign(:proceso, Proceso.new())
  end

  it "renders new proceso form" do
    render

    assert_select "form[action=?][method=?]", procesos_path, "post" do
    end
  end
end
