require 'rack/test'

module Ginseng
  module Web
    class SinatraTest < Test::Unit::TestCase
      include ::Rack::Test::Methods

      def setup
        @config = Config.instance
      end

      def app
        return Sinatra
      end

      def test_about
        header 'User-Agent', Package.user_agent
        get '/about'

        assert_predicate(last_response, :ok?)
        assert_equal(%("#{Package.name} #{Package.version}"), last_response.body)
      end

      def test_not_found
        header 'User-Agent', Package.user_agent
        get '/not_found'

        assert_false(last_response.ok?)
        assert_equal(404, last_response.status)
      end

      def test_get
        header 'User-Agent', Package.user_agent
        get '/test/get?param1=aaa'

        assert_predicate(last_response, :ok?)
        params = JSON.parse(last_response.body, symbolize_names: true)

        assert_kind_of(Hash, params)
        assert_equal('aaa', params[:param1])
        assert_nil(params[:param2])
      end

      def test_post
        header 'User-Agent', Package.user_agent
        header 'Content-Type', 'application/json'
        post '/test/post', {param1: 'aaa', param2: 'bbb'}.to_json

        assert_predicate(last_response, :ok?)
        params = JSON.parse(last_response.body, symbolize_names: true)

        assert_kind_of(Hash, params)
        assert_equal('aaa', params[:param1])
        assert_equal('bbb', params[:param2])
      end
    end
  end
end
