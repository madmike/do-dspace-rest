module DSpace
  module Rest
    module DSpaceObjClassMethods

      def rights
        return [:crceate, :delete, :read, :update] if self == Item
        return [:read]
      end

      def list(params)
        get(nil, self::PATH, params)
      end

      def find_by_id(id, expand = [])
        return DSpaceObj.get(nil, "#{self::PATH}/#{id}", {'expand' => expand.join(',')})
      end

    end
  end
end

