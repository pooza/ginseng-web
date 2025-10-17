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
        @body = request.body&.read.to_s
        request.body&.rewind
        @headers = build_headers
        @params = build_params
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

      get '/test/get/:code' do
        @renderer = JSONRenderer.new
        if Environment.test?
          @renderer.message = @params
        else
          @renderer.status = 404
        end
        return @renderer.to_s
      end

      post '/test/post/:code' do
        @renderer = JSONRenderer.new
        if Environment.test?
          @renderer.message = @params
        else
          @renderer.status = 404
        end
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

      def build_headers
        return request.env.select {|k, _v| k.start_with?('HTTP_')}.transform_keys do |k|
          k.sub(/^HTTP_/, '').downcase.gsub(/(^|_)\w/, &:upcase).tr('_', '-')
        end
      end

      def build_params
        @dest = request.GET.to_h.symbolize_keys
        if request.media_type == 'application/json'
          @dest.merge!(JSON.parse(@body, symbolize_names: true))
        end
        @dest.merge!((env['rack.routing_args'] || {}).symbolize_keys)
        return @dest
      rescue => e
        @logger.error(error: e)
        return params.to_h.symbolize_keys
      end
    end
  end
end
