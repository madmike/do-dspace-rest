require "initializer"
require "lister_example"
require "byid_example"
require "crud_example"
require "has_many_example"

RSpec.describe DCollection do
  include_examples "listers", DCollection
  include_examples "byid", DCollection
  include_examples "has_many", DCollection, "items"

   include_examples "crud"
end

