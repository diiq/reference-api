Aws.config.update(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION']
)

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])

S3_CREDENTIALS = {
  bucket: ENV['S3_BUCKET'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  s3_region: ENV['AWS_REGION'],
  url: ':s3_domain_url',
  path: '/:class/:attachment/:id_partition/:style/:filename'
}
