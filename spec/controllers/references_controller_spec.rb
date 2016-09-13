require 'rails_helper'

require 'spec_helper'

describe ReferencesController do
  let(:body) { JSON.parse(response.body) }
  let(:tag) { user.creator_tag }
  let(:reference) { FactoryGirl.create :reference, tags: [tag] }
  let(:user) { FactoryGirl.create :user }

  before do
    Role.create_permanent_owner
  end

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
        "id", "medium", "notes", "original", "square", "thumb", "tagIDs"
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
        "presigned_put",
        "tagIDs"
      )
    end

    it "creates a reference that I can view" do
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
        "id", "medium", "notes", "original", "square", "thumb", "tagIDs"
      )
    end
  end

  describe "#set_from_url" do
    subject(:do_request) do
      post :set_from_url,
           format: 'json',
           reference_id: reference.id,
           url: "http://image_thing.png"   
    end

    it_behaves_like "an authenticated endpoint"

    it "Sets the image from the given URL" do
      stub_sign_in user
      expect(Reference).to receive(:find).and_return(reference)
      expect(reference).to receive(:set_from_url)
      do_request
    end
  end

  describe "#set_from_url default" do
    subject(:do_request) do
      post :set_from_url,
           format: 'json',
           reference_id: reference.id
    end

    it_behaves_like "an authenticated endpoint"

    it "sets the image from the default presigned put url" do
      stub_sign_in user
      expect(Reference).to receive(:find).and_return(reference)
      expect(reference).to receive(:set_from_presigned_put)
      do_request
    end
  end

  describe "#destroy" do
    subject(:do_request) do
      delete :destroy,
             format: 'json',
             id: reference.id
    end
    let(:second_tag) { FactoryGirl.create :tag }

    it_behaves_like "an authenticated endpoint"

    it "deletes the reference if I own all tags" do
      stub_sign_in user
      reference
      expect { do_request }.to change { Reference.count }.by(-1)
    end

    it "removes tags I own but leaves the reference" do
      stub_sign_in user
      reference.tags << second_tag
      reference.save!
      expect { do_request }.to_not change { Reference.count }
      expect(reference.reload.tags.count).to be(1)
    end
  end

  describe "#add_reference" do
    let!(:new_tag) do
      tag = FactoryGirl.create :tag 
      user.assign_as!(:permanent_owner, to: tag)
      tag
    end

    subject(:do_request) do
      post :add_tag,
           tag_id: tag.id,
           reference_id: reference.id,
           format: 'json'
    end

    it_behaves_like "an authenticated endpoint"

    it "Adds the reference to the tag (or vice versa)" do
      stub_sign_in user
      do_request
      expect(reference.reload.tags).to include(tag)
    end
  end

  describe "#remove_reference" do
    let!(:new_tag) do
      tag = FactoryGirl.create :tag 
      tag.references = [reference]
      tag.save!
      user.assign_as!(:permanent_owner, to: tag)
      tag
    end

    subject(:do_request) do
      post :remove_tag,
           tag_id: tag.id,
           reference_id: reference.id,
           format: 'json'
    end

    it_behaves_like "an authenticated endpoint"

    it "Adds the reference to the tag (or vice versa)" do
      stub_sign_in user
      do_request
      expect(reference.reload.tags).to_not include(tag)
    end
  end
end
