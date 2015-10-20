#!/usr/bin/env ruby  -I lib -I .

require 'dspace/rest'

baseurl, email, password = ARGV
baseurl, email, password = ["https://demo.dspace.org/rest", "admin@admin.edu", "admin"]
baseurl, email, password = ["http://localhost:8080/rest", "admin@admin.edu", "admin"]

baseurl = ask("url of dspace rest endpoint ") unless baseurl
email = ask("email of dspace admin account ") unless email
password =  ask("password for #{email}") unless password

puts "baseurl            #{baseurl}"
puts "credentials email: #{email} password:#{password.gsub(/./, "x")}"


DSpace::Rest::API.start(baseurl)
dspace_api = DSpace::Rest::API.connection
puts dspace_api.login({'email' => email, 'password' => password })

