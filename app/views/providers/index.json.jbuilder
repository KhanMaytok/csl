json.array!(@providers) do |provider|
  json.extract! provider, :id, :provider_type_id, :clinic_area_id, :name, :doctor_id, :ruc
  json.url provider_url(provider, format: :json)
end
