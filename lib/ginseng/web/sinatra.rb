require 'sinatra'
require 'json'

module Ginseng
  module Web
    class Sinatra < Sinatra::Base
      include Package
      set :root, Environment.dir

      def initialize
        super
        @config = config_class.instance
        @logger = logger_class.new
        @logger.info({
          message: 'starting...',
          server: {port: @config['/thin/port']},
          version: package_class.version,
        })
      end

      before do
        @renderer = default_renderer_class.new
        @body = request.body.read.to_s
        @headers = request.env.select{|k, v| k.start_with?('HTTP_')}.map do |k, v|
          [k.sub(/^HTTP_/, '').downcase.gsub(/(^|_)\w/, &:upcase).gsub('_', '-'), v]
        end.to_h
        begin
          @params = JSON.parse(@body).with_indifferent_access
        rescue JSON::ParserError
          @params = params.clone.with_indifferent_access
        end
        @logger.info({request: {path: request.path, params: @params}})
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
        @renderer = default_renderer_class.new
        @renderer.status = e.status
        @renderer.message = e.to_h.delete_if{|k, v| k == :backtrace}
        @renderer.message['error'] = e.message
        Slack.broadcast(e.to_h) unless e.status == 404
        @logger.error(e.to_h)
        return @renderer.to_s
      end

      private

      def default_renderer_class
        return JSONRenderer
      end
    end
  end
end
