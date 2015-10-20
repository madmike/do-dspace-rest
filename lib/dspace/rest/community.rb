
module DSpace
  module Rest
    class Community
      PATH = "/communities"
      include DSpaceObj
      extend DSpaceObjClassMethods

      EXPAND = ["parentCommunity", "collections", "subCommunities", "logo"]
      EXPAND_TO_ARRAY = ["subCommunities", "collections"];

      def self.topCommuities(params)
        return DSpaceObj.get_sublist(nil, self, '/top-communities', params)
      end

      def self.find_by_name(name)
        list({}).each do |com|
          return com if com.attributes['name'] == name.strip
        end
        return nil
      end

      def communities(params)
        return list(Community, params)
      end

      def collections(params)
        return list(Collection, params)
      end

    end

  end
end
