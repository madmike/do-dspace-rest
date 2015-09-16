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

  def login(account)
    uri = @baseurl + "/login"
    @login_token = RestClient.post uri, account.to_json, :content_type => :json, :accept => :json
  end

  def logout
    @login_token = nil;
  end

  def login_token
    return @login_token
  end

  def get(path, params)
    uri = @baseurl + path;
    return get_it(uri, params)
  end

  def get_link(link, params)
    uri = @base + link
    return get_it(uri, params)
  end

  def get_it(uri, params)
    trace "GET", uri, params if (@debug)
    options = {"params" => params, :content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    res = RestClient.get uri, options
    @last_res = JSON.parse(res)
    return @last_res
  end

  def post(action, params)
    uri = @baseurl + action;
    return post_it(uri, params)
  end

  def post_link(link, params)
    uri = @base + link;
    return post_it(uri, params)
  end

  def post_it(uri, params)
    trace "POST", uri, params if (@debug)
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
  def trace(action, uri, params)
    puts "curl -k -4 --silent " +
             " -H 'rest-dspace-token: #{@login_token}'" +
             ' -H "accept: application/json"  -H "Content-Type: application/json"' +
             " -X #{action} '#{uri}'" +
             " -d '#{JSON.generate(params)}'"
  end

end
