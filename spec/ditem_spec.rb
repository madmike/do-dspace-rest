require "do-dspace-rest"
require "connect"
require "lister_example"
require "byid_example"
require "has_many_example"

RSpec.describe DItem do
  include_examples "listers"
  include_examples "byid"
  include_examples "has_many", "bitstreams"
end

