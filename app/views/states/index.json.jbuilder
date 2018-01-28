json.array!(@brstates) do |brstate|
  json.extract! brstate, :id, :nome, :abreviacao
  json.url brstate_url(brstate, format: :json)
end
