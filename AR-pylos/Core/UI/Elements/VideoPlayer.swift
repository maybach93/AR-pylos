//
//  VideoPlayer.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/19/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import AVKit
import SwiftUI

class VideoPlayer: UIView {
    
    var playerLayer = AVPlayerLayer()
    
    init(url: URL?) {
        super.init(frame: .zero)
        guard let url = url else { return }
        let player = AVPlayer(url: url)
        player.isMuted = true
        player.actionAtItemEnd = .none
        player.play()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(_ :)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        playerLayer.player = player
        playerLayer.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspectFill.rawValue)
        
        layer.addSublayer(playerLayer)
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct VideoPlayerView: UIViewRepresentable {

    var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    func makeUIView(context: Context) -> VideoPlayer {
        return VideoPlayer(url: url)
    }

    func updateUIView(_ uiView: VideoPlayer, context: Context) {
    }
}
