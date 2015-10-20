module DSpace
  module Rest
    module DSpaceObjClassMethods

      def list(params)
        sublist( nil, self, params)
      end

      def sublist(parent, klass, params)
        link = klass::PATH
        link = parent.link + link if parent
        l = []
        rest_l = API.connection.get(link, params)
        rest_l.each do |c|
          obj = klass.new(parent, {})
          parse(obj, c)
          l << obj
        end
        return l
      end

      def find_by_id(id, expand = [])
        return get_one(nil, "#{self::PATH}/#{id}", self, expand)
      end

      def get_one(parent, path, klass, expand = [])
        raw_json = API.connection.get(path, {'expand' => expand.join(',')})
        obj = klass.new(parent, {})
        parse(obj, raw_json)
        return obj
      end

      def parse(object, raw_json)
        raw_json.each do |key, value|
          unless key == 'expand'
            #puts "#{key}=#{value}"
            object[key] = value
          end
        end
      end

    end
  end
end
