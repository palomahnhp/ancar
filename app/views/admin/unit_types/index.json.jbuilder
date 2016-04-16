json.array!(@admin_unit_types) do |admin_unit_type|
  json.extract! admin_unit_type, :id
  json.url admin_unit_type_url(admin_unit_type, format: :json)
end
