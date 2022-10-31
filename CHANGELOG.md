# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.3.0] - 2022-10-31

### Changed
* Switch to support [`ykman` `5.0.0`](https://github.com/Yubico/yubikey-manager/releases/tag/5.0.0)
  which moved the `oath` commands.

## [v0.2.1] - 2017-09-08

### Added
* Kill `scdaemon` before executing `ykman` to prevent other apps from blocking
  this workflow.


## [v0.2.0] - 2017-06-06

### Changed
* Switch from copying codes to the clipboard to executing `keystrokes` with
  `osascript`.


## [v0.1.0] - 2017-03-18

Initial Release.

[Unreleased]: https://github.com/guildencrantz/yubioath-alfredworkflow/compare/v0.3.0...HEAD
[v0.3.0]: https://github.com/guildencrantz/yubioath-alfredworkflow/compare/v0.3.0...v0.2.1
[v0.2.1]: https://github.com/guildencrantz/yubioath-alfredworkflow/compare/v0.2.1...v0.2.0
[v0.2.0]: https://github.com/guildencrantz/yubioath-alfredworkflow/compare/v0.2.0...v0.1.0
[v0.1.0]: https://github.com/guildencrantz/yubioath-alfredworkflow/tree/v0.1.0

