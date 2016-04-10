require 'rails_helper'

RSpec.describe "procesos/edit", type: :view do
  before(:each) do
    @proceso = assign(:proceso, Proceso.create!())
  end

  it "renders the edit proceso form" do
    render

    assert_select "form[action=?][method=?]", proceso_path(@proceso), "post" do
    end
  end
end
