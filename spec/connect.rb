require 'do-dspace-rest'
baseurl, email, password = ["http://localhost:8080/rest", "admin@admin.edu", "admin"]
DSpaceRest.start(baseurl)
dspace_api = DSpaceRest.connection
dspace_api.login({'email' => email, 'password' => password })

