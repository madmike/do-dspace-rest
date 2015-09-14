require 'dspace_obj'
require 'dcollection'

class DCommunity < DSpaceObj
  PATH = "communities"

  def self.list(params)
    return DSpaceObj.get_list(nil, PATH, self, params)
  end

  def self.find_by_id(id)
    return DSpaceObj.get_one(nil, "#{PATH}/#{id}", self)
  end

  def self.find_by_name(name)
    list({}).each do |com|
      return com if com.attributes['name'] == name.strip
    end
    return nil
  end

  def collections(params)
    id = self['id'];
    return DSpaceObj.get_list(self, "#{PATH}/#{id}/collections", DCollection, params)
  end

end

