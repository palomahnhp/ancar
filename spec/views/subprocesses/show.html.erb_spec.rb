require 'rails_helper'

RSpec.describe "subprocesses/show", type: :view do
  before(:each) do
    @subprocess = assign(:subprocess, Subprocess.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
