# ThinMP_iOS

`ThinMP` is a simple music player for iOS.

## Demo

### iPhone 14 Plus

<img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/48c92c4d-9e67-4f27-85e7-dbd820473277" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/84c8f096-7b4c-4c8d-8f7a-4d621dd1f8c3" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/44ad1d43-d630-4852-8dfa-78a555c0f24e" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/e3399495-cff3-4580-b57a-d4528b31c852" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/f52cfd64-0ce6-4f44-ad10-c2fc39eedac7" width="156"> 

<img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/4ab3e12e-d171-44d9-960a-ab7f24eb2d7b" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/54a3c7c6-83fb-4c65-9e00-56a7adce20d9" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/616595c7-ef74-407f-8e82-268c8ff0c120" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/918e444c-d0b7-45c0-9059-3b0b98f59926" width="156"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/bf37877e-4cf9-4f4c-9e60-57f95594b9f6" width="156"> 

### iPad Pro

<img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/a04ebb36-f58a-4817-98d0-710297cae3df" width="200"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/77951470-3975-4983-8666-a394353c9125" width="200"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/1d4b439a-bfcb-4811-a365-9e01a28304d0" width="200"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/64f39eca-fb39-4ecd-ae9a-d6ec2afe365e" width="200">

<img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/17abf42a-0ba8-4a10-a6d2-c50afbcd3851" width="200"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/7842b665-38ac-4745-8ad2-0c1fff6711c8" width="200"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/d456b5df-6e57-4b34-bf1b-58b2e556c761" width="200"> <img src="https://github.com/tcode-dev/ThinMP_iOS/assets/42083313/43a32a6f-ea6d-4ffd-bd3d-bd06144fff1b" width="200">

## Features

* device music play
* background play
* favorite artists
* favorite songs
* playlists
* shortcuts

## Environments

* Xcode 27.0
* Swift
* SwiftUI
* SwiftData
* iOS Deployment Target 18
* iPhone 14 Plus (iOS 27)
* iPad Pro (6th generation, iPadOS 27, 12.9-inch)

## Libraries

* Realm - https://realm.io/ (legacy store; kept only to migrate existing data to SwiftData, see [#11](https://github.com/tcode-dev/ThinMP_iOS/issues/11))
* SwiftLint - https://github.com/realm/SwiftLint (run as an SPM build tool plugin via https://github.com/SimplyDanny/SwiftLintPlugins, so no local installation is required)
* SwiftFormat - https://github.com/nicklockwood/SwiftFormat
* Material Icons - https://fonts.google.com/icons?selected=Material+Icons

## SwiftLint

SwiftLint runs on every build of `ThinMP` and `ThinMPTests` through the `SwiftLintBuildToolPlugin` build tool plugin, using `.swiftlint.yml` in the repository root. The plugin ships its own `swiftlint` binary, so nothing needs to be installed locally.

Xcode asks you to trust the plugin the first time it is used on a machine. The build fails with:

```
Plugin “SwiftLintBuildToolPlugin” from package “SwiftLintPlugins” must be enabled before it can be used
```

To enable it, open the Issue Navigator (⌘5), click that error, choose **Trust & Enable** in the dialog, and build again. The choice is stored in Xcode's user settings, so it is needed once per machine and nothing is committed.

`xcodebuild` has no dialog, so pass `-skipPackagePluginValidation` on the command line and in CI, or set it once for the machine:

```
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
```

## Info.plist

Privacy - Media Library Usage Description

## Background Modes

Audio, AirPlay, and Picture in Picture

## Architecture

### View

`View` → `ViewModel` → `Service` → `Repository` → `Model`

### Register

`View` → `Register` → `Repository`

### Persistence boundary

`Repository` is the only layer that touches the persistence store. It exposes plain structs (`Model/Entity`) and value objects so that `Service` and `Register` never depend on store types. `Service` and `Register` receive their dependencies through initializer parameters with default values, so they can be constructed with test doubles.

* `Repository/SwiftData` (`*Repository`) — the current store, backed by `Model/SwiftData` and `SwiftDataStore`.
* `Repository/Realm` (`*RealmRepository`) — the previous store, backed by `Model/Realm` and `RealmStore`. Kept only so existing data can be migrated ([#11](https://github.com/tcode-dev/ThinMP_iOS/issues/11)).
* `Repository/Protocol` — the contracts both implementations satisfy. `ThinMPTests/Repository` runs the same tests against both.

## Migration (Realm → SwiftData)

`ThinMP/Migration/RealmToSwiftDataMigration.swift` runs once from `ThinMP.init()`. On the first launch after the 2026 release it copies favorites, playlists and shortcuts from the Realm file into SwiftData (playlist ids are preserved because shortcuts reference them), marks `realmToSwiftDataMigrated` in `UserDefaults`, and deletes the Realm file. A fresh install is marked as migrated without touching Realm.

`ThinMPTests/Fixtures/legacy.realm` is a Realm file written by the current Realm models with the data described in `LegacyRealmFixture`; `RealmToSwiftDataMigrationTests` migrates it and checks the result through the Repository protocols. Regenerate it with the disabled `generateLegacyRealmFixture` test if the fixture spec changes.

Realm and the migration code are scheduled for removal in the 2027 release; see [#11](https://github.com/tcode-dev/ThinMP_iOS/issues/11).

## Test

`ThinMPTests` uses Swift Testing.

```
xcodebuild -project ThinMP.xcodeproj -scheme ThinMP -destination 'platform=iOS Simulator,name=iPhone 17' -skipPackagePluginValidation test
```

* `ThinMPTests/Repository` — contract tests for the `Repository` protocols. They run against every case of `RepositoryBackend`, so a new persistence store only needs a new case there.
* `ThinMPTests/Service` — tests for the self-healing logic in `Service` (favorites, playlists and shortcuts that reference media no longer in the library), using mock repositories.
* `ThinMPTests/Migration` — the Realm → SwiftData migration, run against an in-memory Realm and against `Fixtures/legacy.realm`.
* `ThinMPTests/Support` — `RepositoryBackend`, mocks, and `FakeMediaItem` for building `SongModel` without the device library.

## App Store

https://apps.apple.com/us/app/thinmp/id1578896579
