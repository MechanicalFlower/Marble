# CHANGELOG
Inspired from [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]
### Added
### Changed
- Correctly end the race if all marble are not exploded ([#57](https://github.com/MechanicalFlower/Marble/pull/57))
### Deprecated
### Removed
### Fixed
- Fix race generation in explosion mode ([#59](https://github.com/MechanicalFlower/Marble/pull/59))
### Security
### Dependencies
- Bump `extractions/setup-just` from 1 to 2 ([#56](https://github.com/MechanicalFlower/Marble/pull/56))
- Bump `dawidd6/action-download-artifact` from 3 to 5 ([#65](https://github.com/MechanicalFlower/Marble/pull/65), [#68](https://github.com/MechanicalFlower/Marble/pull/68))

## [1.6.1]
### Added
- Add AppImage packaging support ([#53](https://github.com/MechanicalFlower/Marble/pull/53))
### Changed
### Deprecated
### Removed
### Fixed
### Security
### Dependencies

## [1.6.0]
### Added
- Add a podium at the end of the race ([#50](https://github.com/MechanicalFlower/Marble/pull/50))
### Changed
- Downgrade rendering settings of Godot ([#49](https://github.com/MechanicalFlower/Marble/pull/49))
- Refactor boost to define multiple power types ([#48](https://github.com/MechanicalFlower/Marble/pull/48))
- Refactor the out of bound detection ([#50](https://github.com/MechanicalFlower/Marble/pull/50))
### Deprecated
### Removed
### Fixed
- Update marble collision mask at each race ([#50](https://github.com/MechanicalFlower/Marble/pull/50))
### Security
### Dependencies

## [1.5.0]
### Added
- Add speed boost areas in races ([#43](https://github.com/MechanicalFlower/Marble/pull/43))
### Changed
### Deprecated
### Removed
### Fixed
- Use a custom `EditorExportPlugin` to set build info ([#41](https://github.com/MechanicalFlower/Marble/pull/41))
- Generate a new chunk at each lap ([#42](https://github.com/MechanicalFlower/Marble/pull/42))
### Security
### Dependencies
- Bump `actions/cache` from 3 to 4 ([#40](https://github.com/MechanicalFlower/Marble/pull/40))

## [1.4.6]
### Added
### Changed
- Better countdown timer ([#38](https://github.com/MechanicalFlower/Marble/pull/38))
- Better rotation camera ([#38](https://github.com/MechanicalFlower/Marble/pull/38))
### Deprecated
### Removed
### Fixed
- Don't block the entire scene on countdown ([#38](https://github.com/MechanicalFlower/Marble/pull/38))
### Security
### Dependencies

## [1.4.5]
### Added
### Changed
- Use a cleaner game icon ([#34](https://github.com/MechanicalFlower/Marble/pull/34))
### Deprecated
### Removed
- Remove LOD scripts ([#35](https://github.com/MechanicalFlower/Marble/pull/35))
### Fixed
- Correct loading of sound effects for the menu ([#27](https://github.com/MechanicalFlower/Marble/pull/27))
- Include `override.cfg` in each export presets ([#28](https://github.com/MechanicalFlower/Marble/pull/28))
- Remove the old collision shape use for the start line mesh ([#36](https://github.com/MechanicalFlower/Marble/pull/36))
### Security
### Dependencies
- Bump `actions/upload-artifact` from 3 to 4 ([#32](https://github.com/MechanicalFlower/Marble/pull/32))

## [1.4.4]
### Added
### Changed
### Deprecated
### Removed
### Fixed
- Publish only to the stable channel for snap ([#25](https://github.com/MechanicalFlower/Marble/pull/25))
### Security
### Dependencies

## [1.4.3]
### Added
- Add web deploy ([#20](https://github.com/MechanicalFlower/Marble/pull/20))
- Add snapcraft packaging ([#22](https://github.com/MechanicalFlower/Marble/pull/22))
### Changed
- Use Justfile as command runner ([#18](https://github.com/MechanicalFlower/Marble/pull/18))
### Deprecated
### Removed
### Fixed
### Security
### Dependencies
- Bump `godot` from 4.1.2 to 4.2 ([#24](https://github.com/MechanicalFlower/Marble/pull/24))

## [1.4.2]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
### Dependencies
- Bump `flatpak/flatpak-github-actions` from 6.2 to 6.3 ([#13](https://github.com/MechanicalFlower/Marble/pull/13))
- Bump `ubuntu` from v20 to v22 ([#15](https://github.com/MechanicalFlower/Marble/pull/15))
- Bump `kobewi/godot-universal-fade` from ddab6c2 to f091514 ([#12](https://github.com/MechanicalFlower/Marble/pull/12))

[Unreleased]: https://github.com/MechanicalFlower/Marble/compare/1.6.1...HEAD
[1.6.1]: https://github.com/MechanicalFlower/Marble/compare/1.6.0...1.6.1
[1.6.0]: https://github.com/MechanicalFlower/Marble/compare/1.5.0...1.6.0
[1.5.0]: https://github.com/MechanicalFlower/Marble/compare/1.4.6...1.5.0
[1.4.6]: https://github.com/MechanicalFlower/Marble/compare/1.4.5...1.4.6
[1.4.5]: https://github.com/MechanicalFlower/Marble/compare/1.4.4...1.4.5
[1.4.4]: https://github.com/MechanicalFlower/Marble/compare/1.4.3...1.4.4
[1.4.3]: https://github.com/MechanicalFlower/Marble/compare/1.4.2...1.4.3
[1.4.2]: https://github.com/MechanicalFlower/Marble/compare/1.4.1...1.4.2
