json.count @tags.count
json.tags do 
  json.array! @tags do |tag|
    json.extract! tag, :id, :name
  end
end
