module DSpace
  module Rest
    class Item < DSpaceObj
      PATH = "/items"
        extend DSpaceObjClassMethods

      EXPAND = ["metadata", "parentCollection", "parentCollectionList", "parentCommunityList", "bitstreams"]
      EXPAND_TO_ARRAY = ["parentCollectionList", "parentCommunityList", "bitstreams"];

      def bitstreams(params)
        return list(Bitstream, params)
      end
    end

  end
end
