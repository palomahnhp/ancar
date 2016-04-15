json.array!(@typeorgs) do |typeorg|
  json.extract! typeorg, :id
  json.url typeorg_url(typeorg, format: :json)
end
