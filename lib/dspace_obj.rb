require 'dspace_rest'

class DSpaceObj

  def initialize(parent, hsh)
    @attributes = hsh
    @parent = parent
  end

  def attributes
    return @attributes
  end

  def []=(key,value)
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
      @attributes = @attributes.merge  App::REST_API.post(link, @attributes)
    else
      App::REST_API.put(link, @attributes)
    end
    return self
  end

  def delete
    return App::REST_API.delete(link)
  end


  def to_detailed_s
    return "#{self.class}[parent=#{@parent.to_s}, #{@attributes}]"
  end

  def to_s
    return "#{super.to_s}:#{link}"
  end

  # if parent.nil?  list all of given klass   (PATH: /<klass::PATH>)
  # otherwise list all of given klass with in self   (PATH: /<@parent.link>/<klass::PATH>)
  def list(klass, params)
    DSpaceObj.get_list(self, klass, params)
  end

  def self.get_list(parent, klass, params)
    return self.get_sublist(parent, klass, "", params)
  end

  def self.get_sublist(parent, klass, subpath, params)
    link = klass::PATH
    link = parent.link + link if parent
    l = []
    rest_l = App::REST_API.get(link, params)
    rest_l.each do |c|
      obj = klass.new(parent, {})
      parse(obj, c)
      l << obj
    end
    return l
  end

  def self.get_one(parent, path, klass, expand = [])
    raw_json =  App::REST_API.get(path, {'expand' => expand.join(',')})
    obj = klass.new(parent, {})
    parse(obj, raw_json)
    return obj
  end

  def self.parse(object, raw_json)
    raw_json.each do |key, value|
      unless key == 'expand'
        object[key] =  value
      end
    end
  end

end

