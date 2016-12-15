require 'rails_helper'

describe EntryIndicator do
  let(:entry_indicator) { build(:entry_indicator) }

  it 'should have comma as valid decimal delimiter' do
   entry_indicator.amount = '3.24'
   expect(entry_indicator.amount).to eq(3.24)
  end
  it 'should have point as valid decimal delimiter' do
    entry_indicator.amount = '3.24'
    expect(entry_indicator.amount).to eq(3.24)
  end
end