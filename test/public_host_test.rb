module Ginseng
  module Web
    # 公開アドレスだけを通す判定 (#138)。⚠ DNS は引かず、resolver を差し替えて測る。
    class PublicHostTest < Test::Unit::TestCase
      def test_public_address_is_returned_for_pinning
        assert_equal('93.184.215.14', allowed('example.com', ['93.184.215.14']))
      end

      def test_internal_addresses_are_rejected
        internals = [
          '127.0.0.1', '10.0.0.1', '172.16.0.1', '192.168.1.1', '169.254.169.254',
          '0.0.0.0', '100.64.0.1', '::1', 'fe80::1', 'fc00::1', '::', '::ffff:127.0.0.1'
        ]

        internals.each {|ip| assert_nil(allowed('example.com', [ip]), ip)}
      end

      # ⚠⚠ **1 本でも内部アドレスを含めば拒否**（混ぜて返すのはリバインディングそのもの）。
      def test_mixed_answers_are_rejected
        assert_nil(allowed('example.com', ['93.184.215.14', '127.0.0.1']))
      end

      def test_ipv4_is_preferred
        assert_equal('93.184.215.14', allowed('example.com', ['2606:2800:21f:cb07:6820:80da:af6b:8b2c', '93.184.215.14']))
      end

      def test_literals_and_single_labels_are_rejected
        ['169.254.169.254', '[::1]', 'localhost', ''].each do |host|
          assert_nil(allowed(host, ['93.184.215.14']), host)
        end
      end

      # ⚠ 解決できない・失敗したら拒否（fail-closed）。
      def test_resolution_failures_are_rejected
        assert_nil(allowed('example.com', []))
        assert_nil(PublicHost.allowed_address('example.com', resolver: ->(_) {raise Resolv::ResolvError}))
      end

      private

      def allowed(host, addrs)
        return PublicHost.allowed_address(host, resolver: ->(_) {addrs})
      end
    end
  end
end
