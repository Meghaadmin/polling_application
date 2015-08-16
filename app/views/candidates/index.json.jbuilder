json.array!(@candidates) do |candidate|
  json.extract! candidate, :id, :name, :age, :admin_id
  json.url candidate_url(candidate, format: :json)
end
