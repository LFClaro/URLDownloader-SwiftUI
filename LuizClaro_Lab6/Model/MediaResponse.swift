//
//  MediaResponse.swift
//  DownloadMusic-Starter
//
//  Created by Apptist Inc. on 2022-04-01.
//

import Foundation
import SwiftUI

//MARK: - Codable: A type that can convert itself into and out of an external representation.
struct MediaResponse: Codable {
    //An array of MusicItem elements
    var results: [MusicItem]
}

//MARK: Use the Identifiable protocol to provide a stable notion of identity to a class or value type. You could use the id property to identify a particular use even if other data fields change
struct MusicItem: Codable, Identifiable {
    
    let id: Int
    let artistName: String
    let trackName: String
    let collectionName: String
    let preview: String
    let artwork: String
    
    var localFile: URL?
    var isDownloading = false
    var downloadLocation: URL?
    var previewURL: URL? {
        return URL(string: preview)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case artistName
        case trackName
        case collectionName
        case preview = "previewUrl"
        case artwork = "artworkUrl100"
    }
    
}

extension MusicItem {
    init(id: Int, artistName: String, trackName: String, collectionName: String, preview: String, artwork: String) {
        self.id = id
        self.artistName = artistName
        self.trackName = trackName
        self.collectionName = collectionName
        self.preview = preview
        self.artwork = artwork
    }
}
