//
//  SongDownload.swift
//  DownloadMusic-Starter
//
//  Created by Apptist Inc. on 2022-04-01.
//

import Foundation
import SwiftUI

//MARK: - This will allow us to download the song from a URL
class SongDownload: NSObject, ObservableObject, URLSessionDelegate {
    
    //MARK: - A URL session task that stores downloaded data to a file
    var downloadTask: URLSessionDownloadTask?
    var downloadURL: URL?
    
    @Published var downloadLocation: URL?
    
    lazy var urlSession: URLSession = {
        //MARK: - Create a URL Session, set a configuration for URLSession
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func fetchSongAtURL(_ item: URL) {
        //MARK: - This will fetch our song at a given URL
        downloadURL = item
        downloadTask = urlSession.downloadTask(with: item)
        downloadTask?.resume()
    }
}

extension SongDownload: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        /*
         MARK: - If the session download had an error, print out error
         */
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //MARK: - Download the URL into a file within our device
        
        let fileManager = FileManager.default
        guard
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
                let lastPathComponent = downloadURL?.lastPathComponent else {
            fatalError()
        }
        let destinationUrl = documentsPath.appendingPathComponent(lastPathComponent)
        do {
            //MARK: - If file already exists, remove it
            if fileManager.fileExists(atPath: destinationUrl.path) {
                try fileManager.removeItem(at: destinationUrl)
            }
        //MARK: - Copy downloaded song into location where we are downloading to
            try fileManager.copyItem(at: location, to: destinationUrl)
            DispatchQueue.main.sync {
                self.downloadLocation = destinationUrl
            }
        } catch {
            print(error)
        }
    }
    
    
}
