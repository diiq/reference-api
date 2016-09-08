json.count @references.count
json.references do 
  json.array! @references do |reference|
    json.extract! reference, :id, :notes
    json.thumb reference.image.url(:thumb)
    json.square reference.image.url(:square)
    json.medium reference.image.url(:medium)
    json.original reference.image.url(:original)
  end
end
