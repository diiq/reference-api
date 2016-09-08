require 'rails_helper'

require 'spec_helper'

describe ReferencesController do
  let(:body) { JSON.parse(response.body) }
  let(:tag) { FactoryGirl.create :tag, name: 'cool' }
  let(:reference) { FactoryGirl.create :reference, tags: [tag] }
  let(:user) { FactoryGirl.create :user, :with_permission, to: :view, this: tag }

  describe "#show" do
    subject(:do_request) do
      get :show,
        format: 'json',
        id: reference.id
    end

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

    it_behaves_like "an authenticated endpoint"

    it "returns a json representation of the reference" do
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body.keys).to contain_exactly(
        "id",
        "presigned_put"
      )
    end

    it "creates a reference that I can view" do
      Role.ensure_exists(:permanent_owner) do |role|
        role.ensure_permission_exists(:always_own)
        role.ensure_permission_exists(:view)
      end

      stub_sign_in user
      do_request
      tags = Reference.find(body['id']).tags
      expect(tags).to include(user.creator_tag)
    end
  end

  describe "#index" do
    subject(:do_request) do
      get :index,
          format: 'json'
    end

    it_behaves_like "an authenticated endpoint"

    it "returns a json representation of the references" do
      reference
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body['count']).to be 1

      returned_properties = body['references'][0].keys
      expect(returned_properties).to contain_exactly(
                        "id",
                        "notes",
                      )
    end
  end
end
