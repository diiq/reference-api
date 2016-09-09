require 'rails_helper'

describe Reference do
  let(:reference) { FactoryGirl.create :reference }

  describe "#presigned_put" do
    it "returns a signed URL for posting to this image's bucket" do
      expect(reference.presigned_put).to match("amazonaws.com.*#{reference.id}")
    end
  end

  describe "#set_from_presigned_put" do
    pending
  end

  describe "#set_from_url" do
    pending
  end
end
