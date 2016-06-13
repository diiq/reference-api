require 'rails_helper'

describe Reference do
  let(:reference) { FactoryGirl.create :reference }

  describe "#presigned_put" do
    it "returns a signed URL for posting to this image's bucket" do
      expect(reference.presigned_put).to match("amazonaws.com.*#{reference.id}")
    end
  end
end
