require "connect"
require "lister_example"
require "byid_example"

RSpec.describe DSpace::Rest::Bitstream do
  include_examples "listers"
  include_examples "byid"
end

