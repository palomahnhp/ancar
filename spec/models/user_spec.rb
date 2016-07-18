require 'rails_helper'

describe User do

  subject { build(:user) }

  it "is valid and unique" do
    user1 = create(:user, login: subject.login)
    expect(subject).to be_valid
    expect(user1).not_to be_valid
  end

  describe "administrator?" do
    it "is false when the user is not an admin" do
      expect(subject.administrator?).to be false
    end

    it "is true when the user is an admin" do
      subject.save
      create(:administrator, user: subject)
      expect(subject.administrator?).to be true
    end
  end

  describe "valuator?" do
    it "is false when the user is not a valuator" do
      expect(subject.valuator?).to be false
    end

    it "is true when the user is a valuator" do
      subject.save
      create(:valuator, user: subject)
      expect(subject.valuator?).to be true
    end
  end

  describe "manager?" do
    it "is false when the user is not a manager" do
      expect(subject.manager?).to be false
    end

    it "is true when the user is a manager" do
      subject.save
      create(:manager, user: subject)
      expect(subject.manager?).to be true
    end
  end

  describe "user have organizations" do
    organization = create(:user_organizations, organization_type_id: 1, description: "One organization")
    before(:each) {subject.user_organizations = {user_id: subject.id, organization_id: organization.id} }

    it "triggers the creation of an associated organization" do
      expect(subject.organizations).to be
      expect(subject.organizations.take(1).description.to eq('One organization')
    end

  end

  describe "self.search" do
    it "find users by login" do
      user1 = create(:user, login: "AAA001")
      create(:user, email: "BBB001")
      search = User.search("AAA001")
      expect(search.size).to eq(1)
      expect(search.first).to eq(user1)
    end

    it "returns no results if no search term provided" do
      expect(User.search("    ").size).to eq(0)
    end
  end

end