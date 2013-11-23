require 'net/http'
require 'json'

module Btsync
  class ApiError < Exception
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
      url = base_url
      url.query = URI.encode_www_form(params)
      response = JSON.parse(Net::HTTP.get(url))
      if response['error'] && response['error'] != 0
        raise ::Btsync::ApiError.new(response['error']), response['message']
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
      rescue ::Btsync::ApiError => e
        if e.error_code != 1 # not found
          raise e
        end
      end
      super
    end

  private

    def base_url
      URI::HTTP.build(path: '/api', port: settings[:port], host: settings[:host])
    end

    def default_settings
      {
        host: 'localhost',
        port: 8888
      }
    end
  end
end
