cask "zeed" do
  version "150.0.7871.46.67"
  sha256 "5b63a862a92daa381dbb2e5c716b72aea71f7c4f1e838a5a0411dcad0237d079"

  url "https://github.com/efg-technologies/zeed-browser-dist/releases/download/v#{version}/zeed-#{version}-mac-arm64.dmg",
      verified: "github.com/efg-technologies/zeed-browser-dist/"
  name "Zeed Browser"
  desc "Chromium-based AI browser that thinks with you"
  homepage "https://zeed.run/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey
  depends_on arch: :arm64

  app "Zeed Browser.app"

  # ⚠️ v150.0.7871.46.66 は暫定的に UNSIGNED (ad-hoc 署名のみ) — Apple の
  # Developer ID 証明書上限で新規発行が blocked のため、署名復旧までの stopgap。
  # 復旧後は notarized dmg に戻し、下の caveats を除去すること。Gatekeeper は
  # 初回起動でブロックするので caveats で回避を案内。**Homebrew 既定の
  # quarantine は残す — セキュリティ境界を越える自動 xattr 削除を postflight に
  # 足さないこと** (ユーザー自身が選んで外す想定、caveats 参照)。
  #
  # version bump 時は LaunchServices に新 bundle を再登録し、Dock /
  # IconServices の icon キャッシュを refresh する。これをやらないと
  # macOS が古い (Chromium) icon を表示し続けることがある。
  postflight do
    app_path = "#{appdir}/Zeed Browser.app"
    lsregister = "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks" \
                 "/LaunchServices.framework/Versions/A/Support/lsregister"
    # `getconf DARWIN_USER_CACHE_DIR` returns e.g.
    # /var/folders/xx/yyy.../C/  — the user's per-session caches dir.
    # com.apple.iconservicesagent ここに icon hash → bitmap の cache を置く。
    # Cask の install で bundle が差し替わっても、この cache が古い hash の
    # bitmap (前 install 時の Chromium icon) を保持し続けるため、それを消す。
    user_cache = `/usr/bin/getconf DARWIN_USER_CACHE_DIR`.chomp

    system_command lsregister,
                   args: ["-f", app_path],
                   sudo: false
    # getconf が空 / "/" を返した時は cwd 配下を誤削除しないよう skip
    if user_cache.start_with?("/") && user_cache.length > 1
      system_command "/bin/rm",
                     args:         ["-rf", "#{user_cache}com.apple.iconservicesagent"],
                     sudo:         false,
                     must_succeed: false
    end
    system_command "/usr/bin/killall",
                   args:         ["-q", "Dock", "Finder", "iconservicesagent", "iconservicesd"],
                   sudo:         false,
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/Chromium",
    "~/Library/Caches/Chromium",
    "~/Library/Preferences/org.efg-technologies.com.plist",
    "~/Library/Saved Application State/org.efg-technologies.com.savedState",
  ]

  caveats <<~EOS
    This build (#{version}) is distributed WITHOUT Apple notarization for now
    (ad-hoc signed only) while Developer ID signing is being restored. macOS
    Gatekeeper will block it on first launch. To allow it, either:

      * System Settings -> Privacy & Security -> "Open Anyway", or
      * clear the quarantine flag yourself:
          xattr -dr com.apple.quarantine "/Applications/Zeed Browser.app"

    This affects the first launch only. A notarized build will follow.
  EOS
end
