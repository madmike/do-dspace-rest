#!/usr/bin/env ruby  -I lib -I .

require 'initializer'

puts App::REST_API.login(App::ADMIN_ACCOUNT)

