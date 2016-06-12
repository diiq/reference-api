require 'rails_helper'

describe User do
  subject(:user) { FactoryGirl.create :user }

  describe "permissions" do
    let!(:role) { FactoryGirl.create :role, name: "admin" }
    let!(:permission) { FactoryGirl.create :permission, name: "view", role: role }
    let(:reference) { FactoryGirl.create :reference }

    describe "#assign_as!" do
      it "creates an assigment for the user, role, and object" do
        assignment = user.assign_as! :admin, to: reference
        expect(assignment.role.id).to eq(role.id)
        expect(assignment.user.id).to eq(user.id)
        expect(assignment.object.id).to eq(reference.id)
      end
    end

    describe "may?" do
      it "returns true if the user has been assigned a role with that permission" do
        user.assign_as! :admin, to: reference
        expect(user.may? :view, reference).to be(true)
      end

      it "returns false if the user has not been assigned a role with that permission" do
        expect(user.may? :view, reference).to be(false)
      end
    end
  end
end
