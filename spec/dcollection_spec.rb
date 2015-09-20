require "initializer"
require "lister_example"
require "byid_example"
require "crud_example"
require "has_many_example"

RSpec.describe DCollection do
  include_examples "listers", DCollection
  include_examples "byid", DCollection
  include_examples "has_many", DCollection, "items"

  PROP_KEYS = ["name", "copyrightText", "introductoryText", "shortDescription", "sidebarText"]
  parent = DCommunity.list({})[0]
  include_examples "crud", DCollection, PROP_KEYS, parent


end

