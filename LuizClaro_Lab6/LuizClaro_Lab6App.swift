//
//  LuizClaro_Lab6App.swift
//  LuizClaro_Lab6
//
//  Created by Luiz Fernando Reis on 2022-04-07.
//

import SwiftUI

@main
struct LuizClaro_Lab6App: App {
    var body: some Scene {
        WindowGroup {
            let musicItem = MusicItem(
                id: 538257185,
                artistName: "Foo Fighters",
                trackName: "All My Life",
                collectionName: "One by One",
                preview: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/70/76/52/707652a4-2877-5883-44e5-fdcba577e695/mzaf_6680662479839614410.plus.aac.p.m4a",
                artwork: "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/dc/8a/d8/dc8ad8d7-4000-ae10-a7aa-975e6bc6752f/source/1000x1000bb.jpg")
            
            SongDetailView(musicItem: .constant(musicItem)).preferredColorScheme(.dark)
        }
        
    }
}
