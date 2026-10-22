# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

ThinMP は端末内の音楽ライブラリ(MediaPlayer フレームワーク)を再生する SwiftUI の音楽プレイヤーで、お気に入り・プレイリスト・ショートカットを SwiftData に保存する。Xcode プロジェクトは 1 つで、スキームは `ThinMP` のみ、ターゲットは `ThinMP` と `ThinMPTests`。実行時に使うサードパーティの依存は無く、パッケージは SwiftLintPlugins だけ。

## コマンド

```sh
# ビルド
xcodebuild -project ThinMP.xcodeproj -scheme ThinMP -destination 'platform=iOS Simulator,name=iPhone 17' -skipPackagePluginValidation build

# 全テスト(Swift Testing)
xcodebuild -project ThinMP.xcodeproj -scheme ThinMP -destination 'platform=iOS Simulator,name=iPhone 17' -skipPackagePluginValidation test

# 1 つのスイート / テストだけ
xcodebuild ... test -only-testing:ThinMPTests/<SuiteName>
xcodebuild ... test -only-testing:ThinMPTests/<SuiteName>/<testName>

# 整形(ビルドには含まれない。設定は .swiftformat)
swiftformat --lint .   # 変更点の表示のみ
swiftformat .          # その場で書き換える
```

- コマンドラインでは `-skipPackagePluginValidation` が必要。SwiftLint はビルドツールプラグイン(SwiftLintPlugins、設定は `.swiftlint.yml`)として両ターゲットのビルドのたびに走り、`xcodebuild` では信頼のダイアログを出せないため。lint の違反はビルドの警告 / エラーとして出るので、lint 単体のコマンドは無い。マシンごとに 1 回 `defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES` で設定してもよい(キーの綴りの誤りは Apple 側のもの)。Xcode の GUI では最初のビルドが `Plugin "SwiftLintBuildToolPlugin" … must be enabled` で失敗するので、Issue Navigator でそのエラーから **Trust & Enable** を選ぶ。
- SwiftFormat は別途インストールする(`brew install swiftformat`)。Xcode 拡張(`brew install --cask swiftformat-for-xcode`)も同じ `.swiftformat` を読む。

## アーキテクチャ

レイヤー:

- **読み込み:** `View` → `ViewModel` → `Service` → `Repository` → `Model`。読み込みはすべて `Service` を通すので、ViewModel が読み込みに使う依存は 1 種類になる。組み合わせ(複数の Repository、または Repository と端末のライブラリ)は Service が行う。組み合わせが無いもの(`AlbumsService`、`ArtistsService`、`SongsService`)は委譲するだけ。
- **書き込み:** `View` / `ViewModel` → `Repository` を直接呼ぶ。書き込みには組み合わせが無いため。自分の状態を持つページは ViewModel から書く(編集ページの `save()`、`PlaylistsViewModel` の `create` / `add` / `delete`)。ページに依存しない共通部品(コンテキストメニューのお気に入り / ショートカットのトグルボタン、`MusicPlayer`)は自分で `Repository` を持つので、ページが永続化を配線することはない。読み込みは Service、書き込みは Repository というのは意図した形で、不統一ではない。
- 依存はすべてデフォルト値付きのイニシャライザ引数で注入する(`init(service: XServiceProtocol = XService())`)。テストではモックを渡す。Service と Repository にはすべてプロトコルがある(`Service/Protocol`、`Repository/Protocol`、`Repository/Media/Protocol`)。

Repository は 2 種類:

- `Repository/Media` — `MPMediaQuery` による端末ライブラリの読み取り専用アクセス(クラウドの項目を除くため常に `localItems()` で絞る)。`MPMediaItem` / コレクションを包んだ `Model/Media` の型を返し、値オブジェクト(`SongId`、`AlbumId`、`ArtistId` など)で識別する。
- `Repository/SwiftData` — 永続化ストア。SwiftData に触れる唯一のレイヤーで、外に出すのは素の構造体(`Model/Entity`)と値オブジェクトだけ。`@Model` の型(`Model/SwiftData`)は出さない。すべての Repository が `SwiftDataStore.default` の 1 つの `ModelContext` を共有している(autosave はオフで、書き込みは `store.save()` を呼ぶ)ので、ある Repository の書き込みは別の Repository からすぐ見える。保存した行は `mediaId`(`MPMediaEntityPersistentID` を文字列にしたもの)でメディアを参照する。

自己修復: お気に入り・プレイリスト・ショートカットは、端末から削除されたメディアを参照していることがある。Service は保存してある id をライブラリと照合し、見つからないものだけを削除する。一覧ごと上書きはしない(走査中に再生画面などで追加された項目まで消えるため)。

### 並行処理

- Swift 6 で、`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` と approachable concurrency を有効にしている。`ModelContext` はスレッドセーフではないので、store、SwiftData の Repository、Service、ViewModel はメインアクターに置く。
- `nonisolated` なのはメディアライブラリ側(`Model/Media`、`Repository/Media`)だけ。Service はライブラリの走査を `@concurrent` の static ヘルパーでメインアクターの外に出し、SwiftData の読み書きはメインアクターに残す。
- ViewModel は `@Observable` で、読み込みには `LoadTask` を使う。`LoadTask` は最後に始めた読み込みの結果だけを反映し、呼び出し元の `.task` が打ち切られたら結果を捨てる。

### UI への状態の反映

- `MusicPlayer`(`Player/`)はアプリで 1 つの `@Observable` で、`ThinMPApp` が持ち `.environment` で渡す。`MPMusicPlayerController.applicationMusicPlayer` を包んでおり、通知と Timer のコールバックでは `MainActor.assumeIsolated` を使う。
- `SwiftDataStore.save()` は `.swiftDataStoreDidSave` を投げる。別の場所での書き込みを表示に反映する必要がある View(メニュー内の `RegisterToggleButtonView` など)はこの通知を監視する。SwiftUI の `Menu` / `contextMenu` の中身は開き直しても作り直されず、`onAppear` も呼ばれないため。

### テスト

- `ThinMPTests/Repository` は Repository のプロトコルに対する契約テストで、インメモリの `SwiftDataStore` を使い `RepositoryBackend`(`Support/RepositoryBackend.swift`)の全ケースに対して実行する。永続化の実装を増やすときは、そこに case を足すだけでよい。
- `ThinMPTests/Service` — 自己修復のロジック。モックの Repository を使う。`ThinMPTests/ViewModel` — 読み込み / 打ち切りの挙動と、編集ページの書き込み。モックの Service と Repository を使う。`ThinMPTests/Config` — `UserDefaults` に保存する設定。
- `Support/` には Repository / Service のモック、`FakeMediaItem`(端末のライブラリ無しで `SongModel` を作る)、`UserDefaults.empty()`(テストごとに新しいスイートを作る)がある。

## 規約

- コードのコメントは日本語で書き、今のコードを説明する(変更の理由はコメントではなくコミットメッセージに書く)。コミットメッセージは英語。
- SwiftFormat の設定で、単一式でも `return` を書く、key path(`map(\.x)`)ではなくクロージャ(`map { $0.x }`)を使う、`case .x(let id)` の形にする、を意図的に選んでいる。
- ボタン内のテキストには `Color.primary` / `Color.secondary` を使う。そこで `.foregroundStyle(.primary)` を使うとティント色(青)になる。
- `Assets.xcassets/image` のアイコンは Material Icons(https://fonts.google.com/icons)。新しいアイコンも同じセットから追加する。
- 文字列は `Localizable.xcstrings` / `InfoPlist.xcstrings` にある。
