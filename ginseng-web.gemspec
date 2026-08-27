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

  # ⚠⚠ **rack / sinatra の版の制約には 2 種類ある。混ぜないこと (#128)。**
  #
  #   1. **下限（CVE 由来）** — 各行の `# CVE-...` がそれ。既知の脆弱性が直った版
  #   2. 🔴 **上限（事故由来）** — `~>` で入れていたもの。⚠⚠ **CVE ではない**
  #
  # 🔴 **2025-10-12〜26、モロヘイヤで rack 3.2.3 + Sinatra 4.2.0 の組み合わせにより
  # 「他のユーザーのトークンで投稿が送信される」障害が起きた**（複数ユーザーのほぼ
  # 同時アクセス時）。⚠⚠ **原因は特定できていない。CVE も upstream の Issue も無い。**
  # 正本: pooza/mulukhiya-toot-proxy の `docs/archive/postmortem-2025-10-rack32.md`
  #
  # その対策として 2026-01-24 に `sinatra ~>4.1.0` / `rack ~>3.1.14` を入れた。⚠⚠ **だが
  # 入れた理由をここに書かなかった。** そのため 2026-08-09 に
  # pooza/mulukhiya-toot-proxy#4508 で「CVE 由来の下限は保つ」という判断のもと
  # **上限だけが外された**（rack は 2026-02 の再検証を受けて 2026-02-18 に緩和済み）。
  # ⚠ #4508 の受け入れ条件は staging での通し確認までで、**事故を再現しうる唯一の
  # 条件（同時アクセス）が検査されていない**。
  #
  # ⚠⚠ **いま上限は無い。** 現行は rack 3.2.6+ / sinatra 4.2.1 が本番 4 台で稼働中
  # （モロヘイヤ v5.33.0 以降、`Controller#verify_token_integrity!` を有効にしたまま）。
  #
  # 🔴 **この 4 つ（rack / rack-session / sinatra / puma）を触るときは:**
  #   - **下限を上げるだけ**なら advisory で足りる
  #     （`gh api "/advisories?ecosystem=rubygems&affects=<gem>&per_page=100"`）
  #   - ⚠⚠ **上限を入れる／外す・系列をまたぐときは、同時アクセステストを通すこと。**
  #     postmortem の教訓。2026-02 の再検証は 500 req × 2 並列で不整合 0
  #   - 🔴 **advisory は上の事故を知らない。** `sinatra 4.2.0` は CVE-2025-61921 の
  #     修正版だが、**事故の版そのもの**。advisory だけで床を決めない
  #
  # ⚠ **そもそも lib/ はこの 4 つを一行も使っていない**（`Ginseng::Web::Sinatra` を
  # 消した時点で使う理由が消えた）。制約を持つ場所としてここが正しいかは
  # pooza/mulukhiya-toot-proxy 側へ引き継いである。
  spec.add_dependency 'erb'
  spec.add_dependency 'puma', '>=6.4.3' # CVE-2024-45614
  spec.add_dependency 'rack', '>=3.1.14' # CVE-2025-46727
  spec.add_dependency 'rack-session', '>=2.1.1' # CVE-2025-46336
  spec.add_dependency 'rss'
  spec.add_dependency 'sassc'
  spec.add_dependency 'sinatra', '>=4.1.0' # CVE-2024-21510
  spec.add_dependency 'slim'
  spec.add_dependency 'tilt', '>=2.1.0'
end
