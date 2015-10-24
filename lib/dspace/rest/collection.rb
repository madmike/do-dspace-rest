
module DSpace
  module Rest
    class Collection < DSpaceObj
      PATH = "/collections"
      extend DSpaceObjClassMethods

      def self.valid_attributes
        DSpaceObj.valid_attributes + %W(parentCommunityList parentCommunity items license logo)
      end

      def self.find_by_name(name)
        # TODO figure out hwo to use /collections/find-collection
        list({}).each do |com|
          return com if com.attributes['name'] == name.strip
        end
        return nil
      end

      def items(params)
        return list(Item, params)
      end
    end
  end
end
