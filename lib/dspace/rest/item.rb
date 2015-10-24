module DSpace
  module Rest
    class Item < DSpaceObj
      PATH = "/items"
      extend DSpaceObjClassMethods

      def bitstreams(params)
        return list(Bitstream, params)
      end
    end
  end
end
