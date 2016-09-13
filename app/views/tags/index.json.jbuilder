json.count @tags.count
json.earmarkTag current_user.earmark_tag
json.creatorTag current_user.creator_tag
json.tags do 
  json.array! @tags do |tag|
    json.extract! tag, :id, :name
  end
end
