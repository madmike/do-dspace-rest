
module DSpace
  module Rest
    class Community < DSpaceObj
      PATH = "/communities"
      extend DSpaceObjClassMethods

      EXPAND = ["parentCommunity", "collections", "subCommunities", "logo"]
      EXPAND_TO_ARRAY = ["subCommunities", "collections"];

      def self.topCommuities(params)
        get_list(nil, PATH + '/top-communities', Community, params)
      end

      def self.find_by_name(name)
        list({}).each do |com|
          return com if com.attributes['name'] == name.strip
        end
        return nil
      end

      def description
        return @attributes['shortDescription']
      end

      def introduction
        return @attributes['introductoryText']
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
