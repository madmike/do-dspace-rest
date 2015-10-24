require 'dspace/rest'
baseurl, email, password = ["http://localhost:8080/rest", "admin@admin.edu", "admin"]
DSpace::Rest::API.start(baseurl)
dspace_api = DSpace::Rest::API.connection
dspace_api.login({'email' => email, 'password' => password})

module DSpace
  module Rest
    class Bitstream
      EXPAND = ["parent", "policies"]
      EXPAND_TO_ARRAY = ["policies"]
    end

    class Collection
      EXPAND = ["parentCommunityList", "parentCommunity", "items", "license", "logo"];
      EXPAND_TO_ARRAY = ["parentCommunityList", "items"];
    end

    class Community
      EXPAND = ["parentCommunity", "collections", "subCommunities", "logo"]
      EXPAND_TO_ARRAY = ["subCommunities", "collections"];
    end

    class Item
      EXPAND = ["metadata", "parentCollection", "parentCollectionList", "parentCommunityList", "bitstreams"]
      EXPAND_TO_ARRAY = ["parentCollectionList", "parentCommunityList", "bitstreams"]
    end
  end
end
