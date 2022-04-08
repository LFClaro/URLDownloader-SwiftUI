//
//  AudioPlayer.swift
//  DownloadMusic-Starter
//
//  Created by Apptist Inc. on 2022-04-01.
//

import UIKit
import SwiftUI
import AVKit

//MARK: - Use a UIViewControllerRepresentable instance to create and manage a UIViewController object in your SwiftUI interface. Adopt this protocal in one of your app's custom instances, and use its methods to create, update, and tear down your view controller
struct AudioPlayer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        //MARK: - This will create a AVPlayerViewController
        //Pass the AVPlayer a songURL
        let player = AVPlayer(url: songURL)
        //Set the player to autoplay
        player.rate = 1
        //Initialize a AVPlayerViewController
        let playerViewController = AVPlayerViewController()
        //Set the player to the avplayer item
        playerViewController.player = player
        //Player enters fullscreen when playback begins
        playerViewController.entersFullScreenWhenPlaybackBegins = true
        //Change player colour
        playerViewController.view.backgroundColor = UIColor.orange
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    //MARK: - The url for the downloaded song
    let songURL: URL
}

class PlayPauseButton: UIView {
    var kvoRateContext = 0
    var avPlayer: AVPlayer?
    var isPlaying: Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
    }

    func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: "rate", options: .new, context: &kvoRateContext)
    }

    func setup(in container: UIViewController) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)

        updatePosition()
        updateUI()
        addObservers()
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        updateStatus()
        updateUI()
    }

    private func updateStatus() {
        if isPlaying {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
    }

    func updateUI() {
        if isPlaying {
            setBackgroundImage(name: "pause-button")
        } else {
            setBackgroundImage(name: "play-button")
        }
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 100),
            heightAnchor.constraint(equalToConstant: 100),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
    }

    private func setBackgroundImage(name: String) {
        UIGraphicsBeginImageContext(frame.size)
        UIImage(named: name)?.draw(in: bounds)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }

    private func handleRateChanged() {
        updateUI()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else { return }

        switch context {
        case &kvoRateContext:
            handleRateChanged()
        default:
            break
        }
    }
}
