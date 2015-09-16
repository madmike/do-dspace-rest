require 'dspace_rest'

class DSpaceObj

  def initialize(parent, hsh)
    @attributes = hsh
    @parent = parent
  end

  def save
    if (@parent.nil?) then
      @attributes = @attributes.merge  App::REST_API.post(self.class::PATH, @attributes)
    else
      link = @parent.attributes['link'];
      @attributes = @attributes.merge  App::REST_API.post_link("#{link}#{self.class::PATH}", @attributes)
    end
    return self
  end


  def delete
    return App::REST_API.delete(self.class::PATH + "/#{@attributes['id']}")
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

  def to_detailed_s
    return "#{self.class}[parent=#{@patent}, #{@attributes}]"
  end

  # if parent.nil?  list all of given klass   (PATH: /<klass::PATH>)
  # otherwise list all of given klass with in self   (PATH: /<@parent.link>/<klass::PATH>)
  def list(klass, params)
    DSpaceObj.get_list(self, klass, params)
  end

  def self.get_list(parent, klass, params)
    l = []
    if (parent.nil?) then
      rest_l = App::REST_API.get(klass::PATH, params)
    else
      rest_l = App::REST_API.get_link(parent.attributes['link'] + "#{klass::PATH}", params)
    end
    rest_l.each do |c|
      obj = klass.new(parent, {})
      parse(obj, c)
      l << obj
    end
    return l
  end

  def self.get_one(parent, path, klass)
    raw_json =  App::REST_API.get(path, {})
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

