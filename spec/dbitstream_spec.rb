require "initializer"
require "lister_example"
require "byid_example"

restapi = App::REST_API

RSpec.describe DBitstream do
  include_examples "listers"
  include_examples "byid"
end

