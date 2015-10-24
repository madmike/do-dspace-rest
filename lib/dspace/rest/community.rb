
module DSpace
  module Rest
    class Community < DSpaceObj
      PATH = "/communities"
      extend DSpaceObjClassMethods

      def self.valid_attributes
        DSpaceObj.valid_attributes + %w(parentCommunity collections subCommunities logo)
      end

      def self.topCommuities(params)
        get_list(nil, PATH + '/top-communities', Community, params)
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
