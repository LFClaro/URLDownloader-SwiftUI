//
//  SongDetailView.swift
//  DownloadMusic-Starter
//
//  Created by Apptist Inc. on 2022-04-01.
//

import SwiftUI

struct SongDetailView: View {
    
    //MARK: - Use a binding to create a two-way connection between a property that stores data, and a view that displays and changes the data.
    @Binding var musicItem: MusicItem
    //MARK: - SwiftUI manages the storage of a property you declare as a state. When the value changes, SwiftUI updates the parts of the view hierarchy that depend on the value. Use state as the single source of truth for a given value stored in a view hierarchy. A State instance isn't the value itself; it's a means of reading and writing the value.
    @State private var playMusic = false
    //MARK: - A property wrapper type that subscribes to an observable object and invalidates a view whenever the observable object changes.
    @ObservedObject var download = SongDownload()
    
    var musicImage: UIImage? = nil
    
    //MARK: - Create the body of the view
    var body: some View {
        ZStack {
            Color("HalfTunesRed").ignoresSafeArea()
            VStack {
                GeometryReader { reader in
                    VStack {
                        Spacer()
                        
                        AsyncImage(url: URL(string: "\(self.musicItem.artwork)")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                            .cornerRadius(50)
                            .frame(width: reader.size.width * 0.8,height: reader.size.height * 0.4)
                            .padding()
                            .shadow(radius: 20)
                        Text("**_\(self.musicItem.trackName)_** - \(self.musicItem.artistName)").font(.title)
                        Text("_\(self.musicItem.collectionName)_")
                        
                        Spacer()
                        
                        Button(action: self.downloadButtonTapped) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.orange)
                                    .frame(width: reader.size.width / 2, height: reader.size.height / 12)
                                    .shadow(radius: 10)
                                Text(self.download.downloadLocation == nil ? "Download" : "Listen").font(.largeTitle)
                            }
                        }
                        
                        Spacer()
                        Spacer()
                    }.frame(maxWidth: .infinity, alignment: .center)
                } //Use this method when you want to present a modal view to the user when a Boolean value you provide is true
            }
        }
        .foregroundColor(.white)
        .sheet(isPresented: self.$playMusic) {
            return AudioPlayer(songURL: self.download.downloadLocation!)
        }
    }

func downloadButtonTapped() {
    if self.download.downloadLocation == nil {
        guard let previewUrl = self.musicItem.previewURL else {
            return
        }
        self.download.fetchSongAtURL(previewUrl)
    } else {
        self.playMusic = true
    }
}
}

struct SongDetailView_Previews: PreviewProvider {
    
    struct PreviewWrapper: View {
        @State private var musicItem = MusicItem(id: 538257185,
                           artistName: "Foo Fighters",
                           trackName: "All My Life",
                           collectionName: "One by One",
                           preview: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/70/76/52/707652a4-2877-5883-44e5-fdcba577e695/mzaf_6680662479839614410.plus.aac.p.m4a",
                           artwork: "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/dc/8a/d8/dc8ad8d7-4000-ae10-a7aa-975e6bc6752f/source/1000x1000bb.jpg")
    
    
    var body: some View {
        SongDetailView(musicItem: $musicItem)
    }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
