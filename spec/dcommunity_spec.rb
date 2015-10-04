require "connect"
require "lister_example"
require "byid_example"
require "has_many_example"
require "crud_example"

RSpec.describe DSpace::Rest::DCommunity do
  include_examples "listers"
  include_examples "byid"
  include_examples "has_many", "collections"

  include_examples "crud"

  it "top-communities" do
    obj = DSpace::Rest::DCommunity.topCommuities({})
    expect(obj.is_a?(Array)).to be true
    expect(obj.count <= max_in_list).to be true
  end
end

