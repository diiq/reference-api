json.extract! @reference, :id, :presigned_put
json.tagIDs do
  json.array! @reference.reference_tags.collect(&:tag_id)
end
