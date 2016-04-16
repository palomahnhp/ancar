json.array!(@admin_organization_types) do |admin_organization_type|
  json.extract! admin_organization_type, :id
  json.url admin_organization_type_url(admin_organization_type, format: :json)
end
