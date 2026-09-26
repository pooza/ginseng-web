require 'ipaddr'
require 'resolv'

module Ginseng
  module Web
    # 外部が決めた URL を取りにいくときの、**公開アドレスだけを通す** host_validator (#138)。
    #
    # ⚠⚠ **規則は `mulukhiya-toot-proxy` の `Mulukhiya::RemoteHost` の写し**（本番で
    # 使っている判定）。🔴 **3 つ目の写しを作らないため、正本は ginseng-core へ移す**
    # （→ pooza/ginseng-core の Issue。`Ginseng::HTTP` の `host_validator` の受け口と同じ gem に置く）。
    module PublicHost
      IPV4_LITERAL = /\A\d{1,3}(\.\d{1,3}){3}\z/

      # ⚠ 1 回あたりの解決待ちの上限（秒）。⚠⚠ `Addrinfo.getaddrinfo` は timeout を持てず、
      # 応答を引き延ばす権威 DNS を立てられると描画のスレッドを占有される。
      DNS_TIMEOUT = 3

      # 名前解決の失敗（環境要因）。⚠ fail-closed で拒否に倒す。
      RESOLUTION_ERRORS = [SocketError, Resolv::ResolvError, Errno::ENOENT, Errno::ETIMEDOUT].freeze

      # `IPAddr` の `private?` / `loopback?` / `link_local?` が拾わない予約・特殊用途レンジ。
      # ⚠ **`0.0.0.0` と `::` は 3 述語のいずれも false** なのに、connect(2) はローカルホスト宛と
      # して扱う。
      RESERVED_RANGES = [
        '0.0.0.0/8',
        '100.64.0.0/10',
        '192.0.0.0/24',
        '198.18.0.0/15',
        '224.0.0.0/4',
        '240.0.0.0/4',
        '::/128',
        '64:ff9b::/96',
        '64:ff9b:1::/48',
        'ff00::/8',
      ].map {|v| IPAddr.new(v)}.freeze

      # `Ginseng::HTTP#get` の `host_validator` へ渡す callable。リダイレクトの各ホップがこれを通る。
      # ⚠ **真偽値ではなく IP アドレスを返す**（拒否なら nil）。ginseng-core は文字列が返ると
      # その IP へ接続を固定する — 名前で検証して名前で接続すると DNS リバインディングで抜けられる。
      def self.validator
        return ->(host) {allowed_address(host)}
      end

      # 許可できるなら接続に使う IP アドレスを、拒否なら nil を返す。
      #
      # ⚠ **IP リテラルと、ドットを含まない名前は拒否する**（`localhost` や社内の短い名前）。
      # ⚠⚠ **1 本でも内部アドレスを含めば拒否する。** 公開のほうを選べばよい、ではない —
      # 混ぜて返してくるのはリバインディングそのもの。
      def self.allowed_address(host, resolver: method(:resolve_addresses))
        host = host.to_s
        return nil unless host.include?('.')
        return nil if IPV4_LITERAL.match?(host) || host.start_with?('[')
        addrs = resolver.call(host)
        return nil if addrs.empty?
        return nil if addrs.any? {|ip| internal_address?(ip)}
        # ⚠ IPv4 があれば IPv4 を採る（A と AAAA が混ざって返る）。
        return addrs.find {|ip| IPV4_LITERAL.match?(ip)} || addrs.first
      rescue *RESOLUTION_ERRORS
        return nil
      end

      def self.internal_address?(ip)
        addr = IPAddr.new(ip)
        # ⚠ IPv4-mapped / -compatible は素の IPv4 へ畳んでから突き合わせる（畳まないと
        # `::ffff:127.0.0.1` が family 違いで素通りする）。
        addr = addr.native if addr.ipv4_mapped? || addr.ipv4_compat?
        return true if addr.private? || addr.loopback? || addr.link_local?
        return RESERVED_RANGES.any? {|range| range.include?(addr)}
      end

      # ⚠ タイムアウトすると空配列が返り、`allowed_address` は拒否に倒れる。
      def self.resolve_addresses(host)
        resolver = Resolv::DNS.new
        resolver.timeouts = DNS_TIMEOUT
        return resolver.getaddresses(host).map(&:to_s)
      ensure
        resolver&.close
      end
    end
  end
end
