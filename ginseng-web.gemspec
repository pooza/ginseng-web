require 'yaml'
package = YAML.load_file(File.join(__dir__, 'config/lib.yaml'))['package']

Gem::Specification.new do |spec|
  spec.name = 'ginseng-web'
  spec.version = package['version']
  spec.authors = package['authors']
  spec.email = package['email']
  spec.summary = package['description']
  spec.description = package['description']
  spec.homepage = package['url']
  spec.license = package['license']
  spec.metadata['homepage_uri'] = package['url']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>=3.4'

  # ⚠⚠ **rack / rack-session / sinatra / tilt / puma はここから外した (#127)。**
  # lib/ がこの 5 つを一行も使っていない（`Ginseng::Web::Sinatra` を消した時点で使う理由が
  # 消えた）のに、**版を決めているのはここだった**という捻れを解いたもの。
  #
  # 🔴 **制約の正本は利用側の Gemfile へ移った。**2025-10 のトークン汚染事故
  # （rack 3.2.3 + Sinatra 4.2.0 で「他のユーザーのトークンで投稿が送信される」）は
  # ⚠⚠ **CVE も upstream の Issue も無く、原因も特定できていない**ため、advisory では
  # 版を判定できない。判定材料（リクエスト単位の同一性）を持つのは利用側だけ。
  #
  #   - 事故の正本: pooza/mulukhiya-toot-proxy の `docs/archive/postmortem-2025-10-rack32.md`
  #   - 現行の制約: pooza/mulukhiya-toot-proxy の `Gemfile`
  #     （`sinatra '~> 4.2.1'` / `rack '~> 3.2.5'`、由来と外す条件をコメントで持っている）
  #   - 経緯: pooza/mulukhiya-toot-proxy#4663（移管）/ #4508（上限が外れた回）/ #128（由来を書いた回）
  #
  # ⚠ **ここへ戻さないこと。**戻すと「版を決める場所」と「事故を再現しうる条件を検査できる場所」が
  # また分かれる。⚠ `config/lib.yaml` の `puma.port` は**設定の既定値**なので残してある
  # （gem の依存とは別物）。
  # 🔴 4 系列に分かれて修正されている（`< 4.0.3.1` / `= 4.0.4` / `>= 5.0.0, < 6.0.1.1` /
  # `>= 6.0.2, < 6.0.4`）ので、低い系列の修正版を床にすると**高い系列の未修正版が入る**。
  # ⚠ `ginseng-core` と同じ床。erb 6.0.4 の required_ruby_version は `>= 3.2` で、
  # この gem の `>=3.4` を満たす。
  spec.add_dependency 'erb', '>=6.0.4' # CVE-2026-41316
  spec.add_dependency 'rss'
  spec.add_dependency 'sassc'
  spec.add_dependency 'slim'
end
