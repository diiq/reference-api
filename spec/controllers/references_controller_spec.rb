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
    let(:user) { FactoryGirl.create :user, :with_permission, to: :view, this: reference }

    it_behaves_like "a permissions-protected endpoint"

    it "returns a json representation of the reference" do
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body.keys).to contain_exactly(
        "id",
        "notes"
      )
    end
  end

  describe "#create" do
    subject(:do_request) do
      get :create,
        format: 'json',
        reference: { notes: "hello" }
    end

    let(:user) { FactoryGirl.create :user }

    it_behaves_like "an authenticated endpoint"

    it "returns a json representation of the reference" do
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body.keys).to contain_exactly(
        "id",
        "notes",
        "presigned_put"
      )
    end
  end
end
