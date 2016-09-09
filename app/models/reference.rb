class Reference < ActiveRecord::Base
  # Columns:
  #
  # notes: string
  # For storing notes about what the image is, and where it came from
  #
  # created_at: date
  #
  # updated_at: date
  #
  has_many :reference_tags
  has_many :tags, through: :reference_tags
  has_attached_file :image,
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    styles: {
                      thumb: '200x200>',
                      square: '200x200#',
                      medium: '1024x1024>'
                    }
  validates_attachment_content_type(
    :image, 
    content_type: [
      "image/jpg", 
      "image/jpeg", 
      "image/png", 
      "image/gif"
    ])

  def presigned_put
    # If users are uploading an image, rather than pulling from the
    # browser, we need to give them a temporary place to put that
    # image before it gets converted and stored permanently.
    upload_object.presigned_url(:put)
  end

  def set_from_presigned_put
    self.image = upload_object.get.body
  end

  def set_from_url url
    self.image = open(url)
  end

  private

  def upload_object
    S3_BUCKET.object("uploads/#{id}")
  end
end
