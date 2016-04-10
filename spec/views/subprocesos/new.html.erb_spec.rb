require 'rails_helper'

RSpec.describe "subprocesos/new", type: :view do
  before(:each) do
    assign(:subproceso, Subproceso.new(
      :orden => 1,
      :descripcion => "MyString"
    ))
  end

  it "renders new subproceso form" do
    render

    assert_select "form[action=?][method=?]", subprocesos_path, "post" do

      assert_select "input#subproceso_orden[name=?]", "subproceso[orden]"

      assert_select "input#subproceso_descripcion[name=?]", "subproceso[descripcion]"
    end
  end
end
