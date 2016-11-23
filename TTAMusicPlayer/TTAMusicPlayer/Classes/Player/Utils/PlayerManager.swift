//
//  PlayerManager.swift
//  MusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerManager: NSObject {
    static let sharedPlayerManager = PlayerManager()
    
    var audioPlayer : AVAudioPlayer?
    
    
    var isPlaying : Bool {
        get {
            if let nowPlaying = audioPlayer?.isPlaying {
                return nowPlaying
            } else {
                return false
            }
        }
    }
    
    override class func initialize() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
}


// MARK: - Play Control
extension PlayerManager {
    func play(music : MPMediaItem?) {
        guard let musicURL = music?.assetURL else {
            return
        }
        if musicURL != audioPlayer?.url {
            audioPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            audioPlayer?.prepareToPlay()
        }
        audioPlayer?.play()
        print("PlayMusic")
    }
    
    func pause() {
        if let _ = audioPlayer?.isPlaying {
            audioPlayer?.pause()
            print("PauseMusic")
        }
    }
}
