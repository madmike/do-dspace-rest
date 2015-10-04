# Disclaimer 

This is in its infancy. Bitstream upload is not yet implemented. 

# Install 

install ruby, https://www.ruby-lang.org/en/]

install bundler, http://bundler.io/

run 
    bundle install

# include in Gemfile 
    gem 'do-dspace-rest', :git => 'https://github.com/akinom/do-dspace-rest', :ref => 'master'

# Logging 
set environment variable 

    RESTCLIENT_LOG=stdout
    RESTCLIENT_LOG=filename 
    

# Run Tests 
run 
    rspec -I lib -I .

the file spec/connect.rb defines which dspace rest url to use for the tests 

# generate test data

run 
    .bin/gen_test_data.rb

The script asks which parameters to use; for an example file defining what communities, collections, 
and how many items to generate see .bin/gen_test_data.rb

