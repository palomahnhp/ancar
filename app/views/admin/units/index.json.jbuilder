json.array!(@admin_units) do |admin_unit|
  json.extract! admin_unit, :id
  json.url admin_unit_url(admin_unit, format: :json)
end
