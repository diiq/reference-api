require 'rails_helper'

require 'spec_helper'

describe TagsController do
  let(:body) { JSON.parse(response.body) }
  let(:tag) do
    tag = FactoryGirl.create :tag 
    user.assign_as!(:permanent_owner, to: tag)
    tag
  end
  let(:user) { FactoryGirl.create :user }

  before do
    Role.create_permanent_owner
  end

  describe "#create" do
    subject(:do_request) do
      get :create,
        format: 'json',
        tag: { name: "hello" }
    end

    it_behaves_like "an authenticated endpoint"

    it "returns a json representation of the tag" do
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body.keys).to contain_exactly(
        "id",
        "name"
      )
    end

    it "creates a tag that I can view" do
      stub_sign_in user
      do_request
      user.may?(:view, Tag.find(body['id']))
    end
  end

  describe "#show" do
    subject(:do_request) do
      get :show,
        format: 'json',
        id: tag.id
    end

    it_behaves_like "a permissions-protected endpoint"

    it "returns a json representation of the reference" do
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body.keys).to contain_exactly(
        "id", "name"
      )
    end

    context "a tag you may not see" do
      let(:tag) { FactoryGirl.create :tag }

      it "returns a 403" do
        stub_sign_in user
        do_request
        expect(response.status).to be(403)
      end
    end
  end

  describe "#index" do
    let!(:tag2) do
      tag
      tag2 = FactoryGirl.create :tag 
      user.assign_as!(:permanent_owner, to: tag2)
      tag2
    end

    subject(:do_request) do
      get :index,
          format: 'json'
    end

    it_behaves_like "an authenticated endpoint"

    it "returns a json representation of the references" do
      stub_sign_in user
      do_request
      expect(response.status).to be(200)
      expect(body['count']).to be 2

      returned_properties = body['tags'][0].keys
      expect(returned_properties).to contain_exactly(
        "id", "name"
      )
    end
  end

  # describe "#set_from_url default" do
  #   subject(:do_request) do
  #     post :set_from_url,
  #          format: 'json',
  #          reference_id: reference.id
  #   end

  #   it_behaves_like "an authenticated endpoint"

  #   it "sets the image from the default presigned put url" do
  #     stub_sign_in user
  #     expect(Reference).to receive(:find).and_return(reference)
  #     expect(reference).to receive(:set_from_presigned_put)
  #     do_request
  #   end
  # end

  # describe "#destroy" do
  #   subject(:do_request) do
  #     delete :destroy,
  #            format: 'json',
  #            id: reference.id
  #   end
  #   let(:second_tag) { FactoryGirl.create :tag }

  #   it_behaves_like "an authenticated endpoint"

  #   it "deletes the reference if I own all tags" do
  #     stub_sign_in user
  #     reference
  #     expect { do_request }.to change { Reference.count }.by(-1)
  #   end

  #   it "removes tags I own but leaves the reference" do
  #     stub_sign_in user
  #     reference.tags << second_tag
  #     reference.save!
  #     expect { do_request }.to_not change { Reference.count }
  #     expect(reference.reload.tags.count).to be(1)
  #   end
  # end
end
