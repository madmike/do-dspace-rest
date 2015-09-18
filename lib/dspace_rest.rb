require 'rest-client'
require 'json'

class DSpaceRest

  # TODO integrate with logging
  def initialize(baseurl, debug)
    @baseurl = baseurl     # http://localhost:8080/rest
    @path = URI(baseurl).path     # /rest
    @base = baseurl.sub(@path, '')  # http://localhost:8080
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
    trace "GET", uri, params if (@debug)
    res = RestClient.get uri, {"params" => params}.merge(build_options)
    @last_res = JSON.parse(res)
    return @last_res
  end

  def post(action, params)
    uri = @baseurl + action;
    trace "POST", uri, params if (@debug)
    @last_res = RestClient.post uri, params.to_json, build_options
    @last_res = JSON.parse(@last_res)
    return @last_res
  end

  def put(who, params)
    uri = @baseurl + who
    trace "PUT", uri, params if (@debug)
    @last_res = RestClient.put uri, params.to_json, build_options
    return @last_res
  end

  def delete(who)
    uri = @baseurl + who;
    trace "DELETE", uri, nil if (@debug)
    @last_res = RestClient.delete uri, build_options
    return @last_res
  end

  private

  def build_options
    options = {:content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    return options
  end

  def trace(action, uri, params)
    cmd = "curl -k -4 --silent " +
        " -H 'rest-dspace-token: #{@login_token}'" +
        ' -H "accept: application/json"  -H "Content-Type: application/json"' +
        " -X #{action} '#{uri}'";
    cmd = cmd + " -d '#{JSON.generate(params)}'" if params
    puts cmd;
  end

end
