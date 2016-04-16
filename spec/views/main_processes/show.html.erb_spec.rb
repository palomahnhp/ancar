require 'rails_helper'

RSpec.describe "main_processes/show", type: :view do
  before(:each) do
    @main_process = assign(:main_process, MainProcess.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
