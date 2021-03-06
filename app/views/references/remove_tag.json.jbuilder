json.extract! @reference, :id, :notes
json.thumb @reference.image.url(:thumb)
json.square @reference.image.url(:square)
json.medium @reference.image.url(:medium)
json.original @reference.image.url(:original)
json.tagIDs do
  json.array! @reference.reference_tags.collect(&:tag_id)
end
