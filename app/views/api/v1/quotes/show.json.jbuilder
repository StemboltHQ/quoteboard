json.quote do
  json.quoted_person @quote.person.preferred_name
  json.body @quote.body
  json.location @quote.location if @quote.location
end
