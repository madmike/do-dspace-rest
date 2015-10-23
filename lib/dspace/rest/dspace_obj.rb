module DSpace
  module Rest
    class DSpaceObj
      attr_reader :attributes, :parent

      def initialize(parent, hsh)
        @attributes = hsh
        @parent = parent
      end

      def id
        return @attributes['id']
      end

      def handle
        return @attributes['handle']
      end

      def name
        return @attributes['name']
      end

      def link
        return "#{self.class::PATH}/#{self.id}"
      end

      def save
        if (id)
          link = self.link
        else
          link = self.class::PATH
          link = @parent.link + link if @parent
        end
        if id.nil? then
          @attributes = @attributes.merge API.connection.post(link, @attributes)
        else
          API.connection.put(link, @attributes)
        end
        return self
      end

      def delete
        return API.connection.delete(link)
      end

      def to_s
        return "#{self.class.to_s}:#{link}"
      end

      def list(klass, params)
        DSpaceObj.get(self, self.link + klass::PATH, params)
      end

      def self.get(parent, path, params)
        convert_value(parent, API.connection.get(path, params))
      end

      # TODO there really should be a parentList request - instead of the current parentComm/CollList
      def parents
        parents = []
        if @attributes.key?['parentCollectionList'] then
          parents =  DSpaceObj.convert['parentCollectionList']
        end
        if @attributes['parentCommunity'] then
          com = DSpaceObj.convert['parentCommunity']
          parents << com if com
        end
        if @attributes['parentCommunityList'] then
            list =  DSpaceObj.convert['parentCommunityList']
            parents += list if list
        end
        parents
      end

      def DSpaceObj.createFromHash(parent, value)
        case value['type']
          when 'item'
            instance = Item.new(parent, value)
          when 'collection'
            instance = Collection.new(parent, value)
          when 'community'
            instance = Community.new(parent, value)
          else
            instance = value
        end
        instance
      end

      def DSpaceObj.convert_value(parent, value)
        if value.class == Array then
          new_value = value.collect { |o| DSpaceObj.convert_value(parent, o) }
        elsif value.class == Hash then
          new_value = DSpaceObj.createFromHash(parent, value)
        else
          new_value = value
        end
        new_value
      end

    end
  end
end

