require 'rest-client'
require 'json'

module DSpace
  module Rest
    class API
      @@rest_api = nil

      def self.start(baseurl)
        raise "can't start new connection while #{baseurl} is stil open" if @@rest_api
        @@rest_api = API.new(baseurl)
      end

      def self.stop
        @@rest_api= nil
      end

      def self.connection
        return @@rest_api
      end

      def initialize(baseurl)
        @baseurl = baseurl # http://localhost:8080/rest
        @path = URI(baseurl).path # /rest
        @base = baseurl.sub(@path, '') # http://localhost:8080
        @last_res = nil;
        @login_token = nil;
      end

      def to_s
        return "##{self.class}(#{@baseurl})"
      end

      def login(account)
        uri = @baseurl + "/login"
        @login_token = RestClient.post uri, account.to_json, :content_type => :json, :accept => :json, :verify_ssl => OpenSSL::SSL::VERIFY_NONE
      end

      def logout
        @login_token = nil;
      end

      def login_token
        return @login_token
      end

      def get(path, params)
        uri = @baseurl + path;
        res = RestClient.get uri,  { :params => params}.merge(build_options)
        @last_res = JSON.parse(res)
      end

      def post(action, params)
        uri = @baseurl + action;
        @last_res = RestClient.post uri, params.to_json, build_options
        @last_res = JSON.parse(@last_res)
      end

      def put(who, params)
        uri = @baseurl + who
        @last_res = RestClient.put uri, params.to_json, build_options
      end

      def delete(who)
        uri = @baseurl + who;
        @last_res = RestClient.delete uri, build_options
      end

      private

      def build_options
        options = {:content_type => :json, :accept => :json, :verify => OpenSSL::SSL::VERIFY_NONE}
        options['rest-dspace-token'] = @login_token unless  @login_token.nil?
        options
      end

    end
  end
end

