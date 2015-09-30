#!/usr/bin/env ruby  -I lib -I .
require 'yaml';
require 'faker';
require "highline/import"
require 'do-dspace-rest'


baseurl, test_data_file, email, password = ARGV
baseurl, test_data_file, email, password = ["http://localhost:8080/rest", "bin/gen_test_data.yml", "admin@admin.edu", "admin"]

baseurl = ask("url of dspace rest endpoint ") unless baseurl
test_data_file = ask("test data file (yml format please) ") unless test_data_file
email = ask("email of dspace admin account ") unless email
password =  ask("password for #{email}") unless password

puts "baseurl            #{baseurl}"
puts "test_data_file     #{test_data_file}"
puts "credentials email: #{email} password:#{password.gsub(/./, "x")}"

if ("Y" != ask("continue ? (Y/N)")) then
  return
end

DSpaceRest.start(baseurl)
dspace_api = DSpaceRest.connection
puts dspace_api
dspace_api.login({'email' => email, 'password' => password })


def generate(file)
  test_data = YAML.load_file(file)
  test_data["communities"].each do |comm|
    parent_name = comm["name"];
    if parent_name then
      parent = find_or_create_community(parent_name)
      puts "community #{parent.handle}\t#{parent.name}"
      collections = comm["collections"];
      if (collections) then
        collections.each do |col|
          coll = find_or_create_collection(parent, col["name"])
          puts "collection in #{parent.name}\t#{coll.handle}\t#{coll.name}\t"
          nretry = 0;
          n = col["nitems"] || 0
          n.times do

            md = fake_metadata
            item = DItem.new(coll, {"metadata" => md})
            success = false
            while (not success) do
              begin
                item.save
                puts "item in #{parent.name}\t#{coll.handle}\t#{coll.name}\t#{item.handle}\t#{item.name}"
                success = true
              rescue RestClient::InternalServerError => e
                $stderr.puts "rest create item error: " + e.to_s
                success = false
                nretry = nretry + 1
              end
            end
            puts "WARNING: item cretion in #{parent.name}\t#{coll.handle}\t#{coll.name}: #{nretry} failures for #{n} items" if nretry > 0
          end
        end
      end
    end
  end
end

def find_or_create_community(comm_name)
  com = DCommunity.find_by_name(comm_name)
  if (com.nil?) then
    com = DCommunity.new(nil, "name" => comm_name)
    com.save
  end
  return com
end

def find_or_create_collection(parent, name)
  coll = DCollection.find_by_name(name)
  if (coll.nil?) then
    coll = DCollection.new(parent, {"name" => name})
    coll.save
  end
  return coll
end

def find_or_create_item(parent, metadata)

end

def fake_metadata
  md_values = []

  authors = [];
  (1+rand(3)).times do
    author = "#{Faker::Name.last_name}, #{Faker::Name.first_name}"
    md_values << metadata('dc.contributor.author', author)
  end
  md_values << metadata('dc.type', 'Article')

  title= Faker::Book.title
  md_values << metadata('dc.title', title)
  md_values << metadata('dc.publisher', Faker::Book.publisher)
  md_values << metadata('dc.date.issued', Faker::Date.between("1/1/2000", DateTime.now).to_s)
  #journal =  Faker::Commerce.department;
  journal = title.split[0]
  if (0 == rand(1)) then
    journal = "Journal of " + journal
  else
    journal = journal + " Journal";
  end
  md_values << metadata('dc.relation.ispartofseries', journal)

  # abstract with up to three paragraphs containing up to 10 sentences - where sentences have up to 12 words.
  abstract = "";
  npar = 1 + rand(3)
  nsent = 3 + rand(10)
  nwords = 6 + rand(12)
  npar.times do
    nsent.times do
      abstract = abstract + " " + Faker::Lorem.sentence(nwords)
    end
    abstract = "#{abstract}\n";
  end
  md_values << metadata('dc.description.abstract', abstract)

  return md_values
end

def metadata(key, value)
  return {'key' => key, 'value' => value}
end


generate(test_data_file)





