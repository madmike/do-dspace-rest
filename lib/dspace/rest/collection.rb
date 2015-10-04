
module DSpace
  module Rest

    class Collection < DSpaceObj
      PATH = "/collections"
      EXPAND = ["parentCommunityList", "parentCommunity", "items", "license", "logo"];
      EXPAND_TO_ARRAY = ["parentCommunityList", "items"];

      def self.list(params)
        return DSpaceObj.get_list(nil, self, params)
      end

      def self.find_by_id(id, expand = [])
        return DSpaceObj.get_one(nil, "#{PATH}/#{id}", self, expand)
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
