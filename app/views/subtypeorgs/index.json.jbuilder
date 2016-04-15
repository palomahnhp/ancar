json.array!(@subtypeorgs) do |subtypeorg|
  json.extract! subtypeorg, :id
  json.url subtypeorg_url(subtypeorg, format: :json)
end
