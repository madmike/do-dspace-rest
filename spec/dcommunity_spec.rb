require "initializer"
require "lister_example"
require "byid_example"
require "has_many_example"

RSpec.describe DCommunity do
  include_examples "listers", DCommunity
  include_examples "byid", DCommunity
  include_examples "has_many", DCommunity, "collections"

  it "top-communities" do
    obj = DCommunity.topCommuities({})
    expect(obj.is_a?(Array)).to be true
    expect(obj.count <= DEFAULT_MAX_INLIST).to be true
  end
end

