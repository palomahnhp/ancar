require 'rails_helper'

RSpec.describe "subprocesos/index", type: :view do
  before(:each) do
    assign(:subprocesos, [
      Subproceso.create!(
        :orden => 1,
        :descripcion => "Descripcion"
      ),
      Subproceso.create!(
        :orden => 1,
        :descripcion => "Descripcion"
      )
    ])
  end

  it "renders a list of subprocesos" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Descripcion".to_s, :count => 2
  end
end
