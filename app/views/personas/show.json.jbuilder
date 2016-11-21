json.extract! @persona, :id, :name, :email
json.avatar @persona.avatar.url
json.restrictions @persona.restringidos, :id, :name
