
module DSpace
  module Rest
    class Bitstream
      PATH = "/bitstreams"
      include DSpaceObj
      extend DSpaceObjClassMethods

      EXPAND = ["parent", "policies"];
      EXPAND_TO_ARRAY = ["policies"];

    end

  end
end
