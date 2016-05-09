json.array!(@entry_indicators) do |entry_indicator|
  json.extract! entry_indicator, :id
  json.url entry_indicator_url(entry_indicator, format: :json)
end
