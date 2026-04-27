cask "zeed" do
  version "147.0.7727.55.49"
  sha256 "a53189d48e0acde147421033abaf3967af554badb78b22b6f94480f27f59ab48"

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
