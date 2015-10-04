require 'dspace/rest'
baseurl, email, password = ["http://localhost:8080/rest", "admin@admin.edu", "admin"]
DSpace::Rest::API.start(baseurl)
dspace_api = DSpace::Rest::API.connection
dspace_api.login({'email' => email, 'password' => password })

