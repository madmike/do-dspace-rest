# Install 

install ruby, https://www.ruby-lang.org/en/]

install bundler, http://bundler.io/

run 
    > bundle install

# Logging 
set environment variable 

    > RESTCLIENT_LOG=stdout
or    
    > RESTCLIENT_LOG=filename 
    
# Configure 
edit initialzer.rb 

# Run Tests 
run > rspec -I lib -I .


# generate test data
edit gen_test_data.yml

run > ./gen_test_data.rb

