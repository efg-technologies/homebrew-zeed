# homebrew-zeed

Homebrew tap for [Zeed Browser](https://zeed.run) — Chromium-based AI browser that thinks with you.

## Install

```sh
brew tap efg-technologies/zeed
brew install --cask zeed
```

Or in one shot:

```sh
brew install --cask efg-technologies/zeed/zeed
```

## What you get

- **Apple Silicon (arm64)** binary, Chromium 147.0.7727.55 base.
- **Developer ID signed + Apple notarized** dmg — no Gatekeeper warnings,
  no quarantine workarounds.
- First-run setup: paste an [OpenRouter](https://openrouter.ai) API key and you're done.

## Update

```sh
brew upgrade --cask zeed
```

## Uninstall (with all browser data)

```sh
brew uninstall --zap --cask zeed
```

## Roadmap

- [x] **Apple Silicon** (arm64) — current
- [ ] **Universal binary** (Intel + Apple Silicon) — after D-U-N-S
- [x] **Apple notarized** — since v147.0.7727.55.53 (Developer ID signed + stapled)
- [ ] **Upstream `homebrew-cask` submission** (no tap needed)
- [ ] **Sparkle in-app auto-update** — Phase 3

## Issues / source

- App bugs: <https://github.com/efg-technologies/zeed-browser/issues>
- Cask formula bugs: <https://github.com/efg-technologies/homebrew-zeed/issues>

## License

The cask formula in this repo is released under the [BSD 2-Clause License](LICENSE),
matching the homebrew-cask project convention. The Zeed Browser app itself is
distributed under [MPL-2.0](https://github.com/efg-technologies/zeed-browser).
