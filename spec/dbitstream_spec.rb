require "do-dspace-rest"
require "connect"
require "lister_example"
require "byid_example"

RSpec.describe DBitstream do
  include_examples "listers"
  include_examples "byid"
end

