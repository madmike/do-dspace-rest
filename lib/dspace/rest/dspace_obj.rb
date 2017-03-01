module DSpace
  module Rest
    class DSpaceObj
      attr_reader :parent, :attributes

      UNDEFINED_VALUE = Object.new();

      def self.valid_attributes
        %w(id handle name)
      end

      def initialize(parent, hsh)
        @attributes = hsh
      end

      def id() @attributes['uuid'] end
      def handle() @attributes['handle']  end
      def name() @attributes['name'] end

      def get(attr)
        a = attr.to_s
        raise "can't get unknown #{attr}" if self.class.valid_attributes.index(a).nil?
        DSpaceObj.convert_value(nil, @attributes[a] || UNDEFINED_VALUE)
      end

      def set(attr, value)
        a = attr.to_s
        raise "can't assign to #{attr}" if %w(id handle).index(a)
        raise "can't set unknown #{attr}" if self.class.valid_attributes.index(a).nil?
        @attributes[a] = value   # TODO if DSPaceObj - serialize to HASH ???
      end

      def link
        return "#{self.class::PATH}/#{self.id}"
      end

      def save
        if (id)
          link = self.link
        elses
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

      # list klass obects inside self
      def list(klass, params)
        DSpaceObj.get(self, self.link + klass::PATH, params)
      end

      # TODO there really should be a parentList request - instead of the current parentComm/CollList
      def parent_list
        parents = []
        if @attributes.key?('parentCollectionList') then
          parents = DSpaceObj.convert_value(nil, @attributes['parentCollectionList'])
        end
        if @attributes['parentCommunity'] then
          com = DSpaceObj.convert_value(nil, @attributes['parentCommunity'])
          parents << com if com
        end
        if @attributes.key?('parentCommunityList') then
          list =  DSpaceObj.convert_value(nil, @attributes['parentCommunityList'])
          parents += list if list
        end
        parents
      end

      # TODO all dspaceObj should be delivered with info on direct parent
      def DSpaceObj.get(parent, path, params)
        DSpaceObj.convert_value(parent, API.connection.get(path, params))
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

