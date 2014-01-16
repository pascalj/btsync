require 'net/http'
require 'json'

module BtsyncApi
  class ApiError < StandardError
    attr_reader :error_code
    def initialize(error_code)
      @error_code = error_code
    end
  end

  class Api
    attr_accessor :settings

    def initialize(options = {})
      self.settings = default_settings.merge(options)
    end

    def execute(method, options = {})
      params = {method: method.to_s}
      params.merge!(options)
      response = do_request(params)
      if response.is_a?(Hash) && response['error'] && response['error'] != 0
        raise BtsyncApi::ApiError.new(response['error']), response['message']
      end
      response
    end

    def method_missing(method, *args, &block)
      begin
        if args.count == 1
          return execute(method, args[0])
        else
          return execute(method)
        end
      rescue BtsyncApi::ApiError => e
        if e.error_code != 1 # not found
          raise e
        end
      end
      super
    end

  private

    def do_request(params)
      url = base_url
      url.query = URI.encode_www_form(params)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url.request_uri)
      request.basic_auth(settings[:login], settings[:password])
      response = http.request(request)
      JSON.parse(response.body)
    end

    def base_url
      URI::HTTP.build(path: '/api', port: settings[:port], host: settings[:host])
    end

    def default_settings
      {
        host: 'localhost',
        port: 8888,
        login: '',
        password: ''
      }
    end
  end
end
