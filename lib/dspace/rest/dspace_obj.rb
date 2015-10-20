module DSpace
  module Rest

    module DSpaceObj

      def initialize(parent, hsh)
        @attributes = hsh
        @parent = parent
      end

      def attributes
        return @attributes
      end

      def []=(key, value)
        @attributes[key] = value
        return value
      end

      def [](key)
        @attributes[key]
      end

      def parent
        return @parent
      end

      def handle
        return @attributes['handle']
      end

      def name
        return @attributes['name']
      end

      def id
        return @attributes['id']
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

      def to_detailed_s
        return "#{self.class}[parent=#{@parent.to_s}, #{@attributes}]"
      end

      def to_s
        return "#{self.class.to_s}:#{link}"
      end

      # list all of given klass within self
      def list(klass, params)
         self.class.sublist(self, klass, params)
      end

    end

  end
end
