require 'rails/all'

Dir["lib/*.rb"].each {|file| require file.sub(/lib./, '')}

module App
    BASE_URL  = "http://localhost:8080/rest"
    REST_API = DSpaceRest.new(BASE_URL, true)
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

if (false) then
comm_name = "Archival Collections from the Middle East"
com = DCommunity.find_by_name(comm_name)
com.delete if com
com = DCommunity.new("name" => comm_name)
com.save

coll_name = "Archival Garbage"
com = DCollection.new(com, "name" => coll_name)
com.save
end