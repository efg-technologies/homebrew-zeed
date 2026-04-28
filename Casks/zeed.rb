cask "zeed" do
  version "147.0.7727.55.49"
  sha256 "942d4bc59b0f0f2f84c0d5d1775e0328c45f5975e0a45f7df2913e03f131e535"

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
  # 署名+notarize 済みリリースに切り替わったら下記 postflight は削除する。
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Zeed Browser.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/Chromium",
    "~/Library/Caches/Chromium",
    "~/Library/Preferences/org.efg-technologies.com.plist",
    "~/Library/Saved Application State/org.efg-technologies.com.savedState",
  ]
end
