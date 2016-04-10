require 'rails_helper'

RSpec.describe "subprocesos/edit", type: :view do
  before(:each) do
    @subproceso = assign(:subproceso, Subproceso.create!(
      :orden => 1,
      :descripcion => "MyString"
    ))
  end

  it "renders the edit subproceso form" do
    render

    assert_select "form[action=?][method=?]", subproceso_path(@subproceso), "post" do

      assert_select "input#subproceso_orden[name=?]", "subproceso[orden]"

      assert_select "input#subproceso_descripcion[name=?]", "subproceso[descripcion]"
    end
  end
end
