
module DSpace
  module Rest
    class Bitstream < DSpaceObj
      PATH = "/bitstreams"
      extend DSpaceObjClassMethods

      def self.valid_attributes
        DSpaceObj.valid_attributes  +  %w(parent, policies)
      end

    end
  end
end
