require 'dspace/rest'
baseurl, email, password = ["http://localhost:8080/rest", "admin@admin.edu", "admin"]
DSpace::Rest::API.start(baseurl)
dspace_api = DSpace::Rest::API.connection
dspace_api.login({'email' => email, 'password' => password})

module DSpace
  module Rest
    class Bitstream
      EXPAND_TO_ARRAY = ["policies"]
    end

    class Collection
      EXPAND_TO_ARRAY = ["parentCommunityList", "items"];
    end

    class Community
      EXPAND_TO_ARRAY = ["subCommunities", "collections"];
    end

    class Item
      EXPAND_TO_ARRAY = ["parentCollectionList", "parentCommunityList", "bitstreams"]
    end
  end
end
