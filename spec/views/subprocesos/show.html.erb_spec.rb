require 'rails_helper'

RSpec.describe "subprocesos/show", type: :view do
  before(:each) do
    @subproceso = assign(:subproceso, Subproceso.create!(
      :orden => 1,
      :descripcion => "Descripcion"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Descripcion/)
  end
end
