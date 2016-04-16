require 'rails_helper'

RSpec.describe "sub_processes/show", type: :view do
  before(:each) do
    @sub_process = assign(:sub_process, SubProcess.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
