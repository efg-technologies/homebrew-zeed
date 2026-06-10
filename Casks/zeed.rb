cask "zeed" do
  version "147.0.7727.55.55"
  sha256 "0e38ee8bd03f8c42daeb827fa094ef8374cb300d89eaba63f1af13a0b22f66e1"

  url "https://github.com/efg-technologies/zeed-browser-dist/releases/download/v#{version}/zeed-#{version}-mac-arm64.dmg",
      verified: "github.com/efg-technologies/zeed-browser-dist/"
  name "Zeed Browser"
  desc "Chromium-based AI browser that thinks with you"
  homepage "https://zeed.run/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"
  depends_on arch: :arm64

  app "Zeed Browser.app"

  # Unsigned beta — Apple Developer signing は D-U-N-S 取得後に対応予定。
  # ここでは Gatekeeper の quarantine xattr を install 後に外して、起動時の
  # 「開発元が未確認」警告を出さないようにする。
  # 署名+notarize 済みリリースに切り替わったら下記 quarantine 削除は外す。
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

    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", app_path],
                   sudo: false
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
end
