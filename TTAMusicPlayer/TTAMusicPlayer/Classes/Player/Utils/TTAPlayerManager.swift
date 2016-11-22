//
//  TTAPlayerManager.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit
import AVFoundation

class TTAPlayerManager: NSObject {
    static let sharedPlayerManager = TTAPlayerManager()
    
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()

    override class func initialize() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
}


// MARK: - Play Control
extension TTAPlayerManager {
    func play() {
        audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "chengdu.mp3", withExtension: nil)!)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func pause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
}
