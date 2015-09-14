require 'rails/all'

Dir["lib/*.rb"].each {|file| require file.sub(/lib./, '')}

module App
    BASE_URL  = "http://localhost:8080/rest"
    REST_API = DSpaceRest.new(BASE_URL)
    REST_API.login("admin@admin.edu", "admin")
end

#DCollection.list({})
#DCommunity.list({})
#DItem.list({})
#DCommunity.find_by_id(111).collections({})
#DItem.find_by_id(1898)

#d = DCommunity.new("name" => "new")
#d.save
#d.delete
