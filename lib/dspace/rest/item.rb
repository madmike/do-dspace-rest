module DSpace
  module Rest
    class Item < DSpaceObj
      PATH = "/items"
      extend DSpaceObjClassMethods

      def self.valid_attributes
        DSpaceObj.valid_attributes + %w(metadata parentCollection parentCollectionList parentCommunityList bitstreams)
      end

      def bitstreams(params)
        return list(Bitstream, params)
      end
    end
  end
end
