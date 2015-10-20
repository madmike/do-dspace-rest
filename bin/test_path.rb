#!/usr/bin/env ruby  -I lib -I .

require 'dspace/rest'

baseurl, path = ARGV
baseurl, path = ["https://demo.dspace.org/rest", "/test"]
baseurl, path = ["http://localhost:8080/rest", "/test"]

baseurl = ask("url of dspace rest endpoint ") unless baseurl
path =  ask("password for #{email}") unless path

puts "url            #{baseurl}/#{path}"

DSpace::Rest::API.start(baseurl)
dspace_api = DSpace::Rest::API.connection
puts dspace_api.get path, {}
