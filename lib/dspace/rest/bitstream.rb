
module DSpace
  module Rest
    class Bitstream < DSpaceObj
      PATH = "/bitstreams"
      extend DSpaceObjClassMethods

      EXPAND = ["parent", "policies"];
      EXPAND_TO_ARRAY = ["policies"];

    end

  end
end
