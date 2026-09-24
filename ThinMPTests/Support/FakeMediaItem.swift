//
//  FakeMediaItem.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import MediaPlayer
@testable import ThinMP

/// MPMediaItem は端末のライブラリからしか取得できないので、テストでは値を差し替えたサブクラスを使う
final class FakeMediaItem: MPMediaItem, @unchecked Sendable {
    private let fakePersistentID: MPMediaEntityPersistentID
    private let fakeTitle: String
    private let fakeArtist: String
    private let fakeArtistPersistentID: MPMediaEntityPersistentID
    private let fakeAlbumPersistentID: MPMediaEntityPersistentID
    private let fakeDiscNumber: Int
    private let fakeAlbumTrackNumber: Int

    init(persistentID: MPMediaEntityPersistentID, title: String, artist: String, artistPersistentID: MPMediaEntityPersistentID, albumPersistentID: MPMediaEntityPersistentID, discNumber: Int = 0, albumTrackNumber: Int = 0) {
        fakePersistentID = persistentID
        fakeTitle = title
        fakeArtist = artist
        fakeArtistPersistentID = artistPersistentID
        fakeAlbumPersistentID = albumPersistentID
        fakeDiscNumber = discNumber
        fakeAlbumTrackNumber = albumTrackNumber
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var persistentID: MPMediaEntityPersistentID { fakePersistentID }
    override var title: String? { fakeTitle }
    override var artist: String? { fakeArtist }
    override var artistPersistentID: MPMediaEntityPersistentID { fakeArtistPersistentID }
    override var albumPersistentID: MPMediaEntityPersistentID { fakeAlbumPersistentID }
    override var discNumber: Int { fakeDiscNumber }
    override var albumTrackNumber: Int { fakeAlbumTrackNumber }
    override var artwork: MPMediaItemArtwork? { nil }

    override func value(forProperty property: String) -> Any? {
        switch property {
        case MPMediaItemPropertyPersistentID: return fakePersistentID
        case MPMediaItemPropertyTitle: return fakeTitle
        case MPMediaItemPropertyArtist: return fakeArtist
        case MPMediaItemPropertyArtistPersistentID: return fakeArtistPersistentID
        case MPMediaItemPropertyAlbumPersistentID: return fakeAlbumPersistentID
        case MPMediaItemPropertyDiscNumber: return fakeDiscNumber
        case MPMediaItemPropertyAlbumTrackNumber: return fakeAlbumTrackNumber
        case MPMediaItemPropertyArtwork: return nil
        default: return super.value(forProperty: property)
        }
    }
}

extension SongModel {
    static func fake(id: MPMediaEntityPersistentID, title: String = "", artistId: MPMediaEntityPersistentID = 0, albumId: MPMediaEntityPersistentID = 0, disc: Int = 0, track: Int = 0) -> SongModel {
        return SongModel(item: FakeMediaItem(persistentID: id, title: title, artist: "", artistPersistentID: artistId, albumPersistentID: albumId, discNumber: disc, albumTrackNumber: track))
    }
}
