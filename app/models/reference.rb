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
  def presigned_put
    obj = S3_BUCKET.object(id)
    obj.presigned_url(:put)
  end
end
