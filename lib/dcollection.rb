require 'dspace_obj'

class DCollection  < DSpaceObj
  PATH = "collections"

  def self.list(params)
    return DSpaceObj.get_list(nil,PATH, self, params)
  end

  def self.find_by_id(id)
    return DSpaceObj.get_one(nil,"#{PATH}/#{id}", self)
  end

  def self.find_by_name(name)
    list({}).each do |com|
      return com if com.attributes['name'] == name.strip
    end
    return nil
  end

  def items(params)
    id = self['id'];
    return DSpaceObj.get_list(self, "#{PATH}/#{id}/items", DItem, params)
  end

end
