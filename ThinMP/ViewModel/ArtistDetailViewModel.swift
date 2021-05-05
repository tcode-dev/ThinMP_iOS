//
//  ArtistDetail.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import MediaPlayer

class ArtistDetailViewModel: ObservableObject {
    @Published var persistentId: MPMediaEntityPersistentID!
    @Published var name: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var albums: [AlbumModel] = []
    @Published var songs: [SongModel] = []
    @Published var albumCount: Int = 0
    @Published var songCount: Int = 0
    @Published var meta: String?

    init(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
        if MPMediaLibrary.authorizationStatus() == .authorized {
            fetch()
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.fetch()
                }
            }
        }
    }

    func fetch() {
        let repository = ArtistRepository()

        if let artist = repository.findById(persistentId: persistentId) {
            self.name = artist.primaryText
        }

        let albums = repository.findAlbumsById(persistentId: persistentId)

        if !albums.isEmpty {
            self.albums = albums
            self.albumCount = albums.count
            self.artwork = self.albums.first(where: { (album) -> Bool in
                (album.artwork != nil)
            })?.artwork
        }

        self.songs = repository.findSongsById(persistentId: persistentId)
        self.songCount = self.songs.count

        self.meta = "\(self.albumCount) albums, \(self.songCount) songs"
    }
}
