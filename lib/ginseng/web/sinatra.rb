require 'sinatra'

module Ginseng
  module Web
    class Sinatra < Sinatra::Base
      include Package

      set :root, Environment.dir
      set :host_authorization, {permitted_hosts: []}

      def initialize
        super
        @config = config_class.instance
        @logger = logger_class.new
      end

      before do
        @renderer = default_renderer_class.new
        @body = request.body.read
        @headers = request.env.select {|k, _v| k.start_with?('HTTP_')}.transform_keys do |k|
          k.sub(/^HTTP_/, '').downcase.gsub(/(^|_)\w/, &:upcase).tr('_', '-')
        end
        begin
          @params = JSON.parse(@body, symbolize_names: true) || {}
        rescue
          @params = (params || {}).symbolize_keys
        end
        @logger.info(request: {
          method: request.request_method,
          path: request.path,
          params: @params,
          remote: request.ip,
        })
      end

      after do
        status @renderer.status
        content_type @renderer.type
      end

      get '/about' do
        @renderer.message = package_class.full_name
        return @renderer.to_s
      end

      not_found do
        @renderer = default_renderer_class.new
        @renderer.status = 404
        @renderer.message = NotFoundError.new("Resource #{request.path} not found.").to_h
        return @renderer.to_s
      end

      error do |e|
        e = Error.create(e)
        e.package = package_class.name
        @renderer = default_renderer_class.new
        @renderer.status = e.status
        @renderer.message = e.to_h
        @renderer.message.delete(:backtrace)
        @renderer.message['error'] = e.message
        Slack.broadcast(e)
        @logger.error(error: e)
        return @renderer.to_s
      end

      private

      def default_renderer_class
        return JSONRenderer
      end
    end
  end
end
