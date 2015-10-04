module DSpace
  module Rest
    class Item < DSpaceObj
      PATH = "/items"
      EXPAND = ["metadata", "parentCollection", "parentCollectionList", "parentCommunityList", "bitstreams"]
      EXPAND_TO_ARRAY = ["parentCollectionList", "parentCommunityList", "bitstreams"];

      def self.list(params)
        return DSpaceObj.get_list(nil, self, params)
      end

      def self.find_by_id(id, expand = [])
        return DSpaceObj.get_one(nil, "#{PATH}/#{id}", self, expand)
      end

      def bitstreams(params)
        return list(Bitstream, params)
      end
    end

  end
end
