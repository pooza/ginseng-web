module Ginseng
  module Web
    # 🔴🔴 **サブクラスから描いたとき、利用側の `views/` を見ること (#137)。**
    #
    # ⚠⚠ 旧版はクラスを直に書いていたので、`render` も `slim.render` も
    # `Ginseng::Web::SlimRenderer` になり、**gem の `views/` を探して黙って nil** だった。
    class SlimRendererSubclassTest < Test::Unit::TestCase
      # 利用側の `Environment` の代わり。⚠ `dir` だけを別のディレクトリへ向ける。
      module FakeEnvironment
        class << self
          attr_accessor :dir

          def development?
            return false
          end
        end
      end

      # ⚠ ログは「出たこと」を測る対象なので、syslog へは出さずに記録だけする。
      class Recorder
        class << self
          attr_accessor :logs
        end

        def error(message)
          self.class.logs.push(message)
        end
      end

      class Consumer < SlimRenderer
        def environment_class
          return FakeEnvironment
        end

        def logger_class
          return Recorder
        end
      end

      def setup
        @dir = Dir.mktmpdir
        FakeEnvironment.dir = @dir
        Recorder.logs = []
        views = File.join(@dir, 'views')
        FileUtils.mkdir_p(File.join(views, 'fragment'))
        File.write(File.join(views, 'fragment/header.slim'), "p = params[:greeting]\n")
        File.write(File.join(views, 'page.slim'), "div\n  == slim.render 'fragment/header', greeting: 'nested'\n")
      end

      def teardown
        FileUtils.remove_entry(@dir) if @dir && File.exist?(@dir)
      end

      def test_render_uses_the_subclass
        assert_equal('<p>hello</p>', Consumer.render('fragment/header', greeting: 'hello'))
      end

      # ⚠ テンプレートの中の `slim.render` も利用側のクラスで描く（`assign_values`）。
      def test_nested_render_uses_the_subclass
        renderer = Consumer.new('page')

        assert_equal('<div><p>nested</p></div>', renderer.to_s)
      end

      # ⚠ **失敗は nil に倒すが、ログは残す。**
      def test_missing_fragment_is_logged
        assert_nil(Consumer.render('fragment/missing'))
        assert_equal(1, Recorder.logs.size)
        assert_kind_of(RenderError, Recorder.logs.first[:error])
        assert_equal('fragment/missing', Recorder.logs.first[:template])
      end
    end
  end
end
