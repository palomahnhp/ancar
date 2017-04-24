require 'rails_helper'

describe User do

  subject { build(:user) }

  it 'is valid' do
    user1 = create(:user, login: subject.login)
    expect(user1).to be_valid
  end

  it 'is unique' do
    user1 = create(:user, login: subject.login)
    user2 = build(:user, login: subject.login)
    expect(user2).to be_invalid
  end

  describe "validator?" do
    it "is false when the user is not a validator"

    it "is true when the user is a validator"
  end

  describe "is_supervisor?" do
    it "is false when the user is not a validator"

    it "is true when the user is a validator"
  end

  describe "administrator?" do
    it "is false when the user is not an admin"

    it "is true when the user is an admin"
  end

end