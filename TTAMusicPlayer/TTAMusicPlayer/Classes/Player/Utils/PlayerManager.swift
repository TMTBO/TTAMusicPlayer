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

@objc protocol PlayerManagerDelegate : NSObjectProtocol {
    @objc optional func playerManage(_ playerManager : PlayerManager, playingMusic : MPMediaItem)
}

class PlayerManager: NSObject {
    static let sharedPlayerManager = PlayerManager()
    weak var delegate : PlayerManagerDelegate?
    /// 播放器
    var audioPlayer : AVAudioPlayer?
    /// 所有音乐列表
    var musics : [MPMediaItem] = []
    /// 当前正在播放的音乐索引
    var playingIndex : NSInteger = 0
    
    /// 是否正在播放
    var isPlaying : Bool {
        get {
            if let nowPlaying = audioPlayer?.isPlaying {
                return nowPlaying
            } else {
                return false
            }
        }
    }
    
    override init() {
        super.init()
        getMainData()
    }
    
    override class func initialize() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    /// 获取音乐数据
    func getMainData() {
        let allMusic = MPMediaQuery.songs()
        musics = allMusic.items!
    }
}


// MARK: - Play Control
extension PlayerManager {
    /// 播放
    func play(music : MPMediaItem) {
        guard let musicURL = music.assetURL else {
            return
        }
        if musicURL != audioPlayer?.url {
            audioPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            if let index = musics.index(of: music) {
                self.playingIndex = index
            }
            switchPlayerMusicInfo()
        }
        audioPlayer?.play()
        print("PlayMusic: \(music.title!)")
    }
    /// 暂停
    func pause() {
        if let _ = audioPlayer?.isPlaying {
            audioPlayer?.pause()
            print("PauseMusic")
        }
    }
    /// 下一曲
    func next() {
        var nextIndex = playingIndex + 1
        if nextIndex > musics.count - 1 {
            nextIndex = 0
        }
        print("NextMusic")
        play(music: musics[nextIndex])
    }
    /// 上一曲
    func preview() {
        var nextIndex = playingIndex - 1
        if nextIndex < 0 {
            nextIndex = musics.count - 1
        }
        print("PreviewMusic")
        play(music : musics[nextIndex])
    }
    /// 切换播放器音乐信息
    func switchPlayerMusicInfo() {
        if let _ = self.delegate?.responds(to: #selector(self.delegate?.playerManage(_:playingMusic:))) {
            self.delegate?.playerManage?(self, playingMusic: musics[playingIndex])
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension PlayerManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }
}
