require 'dspace_obj'
require 'dcollection'

class DCommunity < DSpaceObj
  PATH = "/communities"
  EXPAND = ["parentCommunity", "collections", "subCommunities", "logo"]
  EXPAND_TO_ARRAY = ["subCommunities", "collections"];

  def self.list(params)
    return DSpaceObj.get_list(nil, self, params)
  end

  def self.topCommuities(params)
    return DSpaceObj.get_sublist(nil, self, '/top-communities', params)
  end

  def self.find_by_id(id, expand = [])
    return DSpaceObj.get_one(nil, "#{PATH}/#{id}", self, expand)
  end

  def self.find_by_name(name)
    list({}).each do |com|
      return com if com.attributes['name'] == name.strip
    end
    return nil
  end

  def communities(params)
    return list(DCommunity, params)
  end

  def collections(params)
    return list(DCollection, params)
  end

end

