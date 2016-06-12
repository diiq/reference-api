require 'rails_helper'

describe ReferencesController do
  let(:body) { JSON.parse(response.body) }

  describe "#show" do
    subject(:do_request) do
      get :show,
        format: 'json',
        id: reference.id
    end

    let(:reference) { FactoryGirl.create :reference }
    let(:user) { FactoryGirl.create :user }
    let!(:role) { FactoryGirl.create :role, name: :owner }
    let!(:permission) { FactoryGirl.create :permission, role: role, name: :view }

    it_behaves_like "a permissions-protected endpoint"

    before do
      user.assign_as! :owner, to: reference
      stub_sign_in user
    end

    it "returns a json representation of the reference" do
      do_request
      expect(response.status).to be(200)
      expect(body.keys).to contain_exactly(
        "id",
        "notes"
      )
    end
  end
end
