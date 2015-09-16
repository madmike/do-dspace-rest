require 'rest-client'
require 'json'

class DSpaceRest

  # TODO integrate with logging
  def initialize(baseurl, debug)
    @baseurl = baseurl
    @path = URI(baseurl).path
    @base = baseurl.sub(@path, '')
    @last_res = nil;
    @login_token = nil;
    @debug = debug
  end

  def login(email, pwd)
    uri = @baseurl + "/login"
    params = {'email' => email, 'password' => pwd}
    @login_token = RestClient.post uri, params.to_json, :content_type => :json, :accept => :json
    return @login_token
  end

  def logout
    @login_token = nil;
  end

  def get(action, params)
    uri = @baseurl + "/" + action;
    return get_it(uri, params)
  end

  def get_link(link, params)
    uri = @base + link
    return get_it(uri, params)
  end

  def get_it(uri, params)
    trace "GET #{uri} params #{params}" if (@debug)
    options = {"params" => params, :content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    res = RestClient.get uri, options
    @last_res = JSON.parse(res)
    return @last_res
  end

  def post(action, params)
    uri = @baseurl + "/" + action;
    return post_it(uri, params)
  end

  def post_link(link, params)
    uri = @base + link;
    return post_it(uri, params)
  end

  def post_it(uri, params)
    trace "POST #{uri} params #{params}" if @debug
    options = {:content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    @last_res = RestClient.post uri, params.to_json, options
    @last_res = JSON.parse(@last_res)
    return @last_res
  end

  def delete(action)
    uri = @baseurl + "/" + action;
    options = {:content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    @last_res = RestClient.delete uri, options
    return @last_res
  end

  def self.clean_params(params)
    params.each do |k, v|
      if (v.class == String) then
        params[k] = v.strip
      end
    end
    return params
  end

  # TODO var args list
  def trace(str)
    puts "\t\t#{str}"
  end
end
