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

let kNONE_TIME = "00:00"

@objc protocol PlayerManagerDelegate : NSObjectProtocol {
    @objc optional func playerManager(_ playerManager : PlayerManager, playingMusic : MPMediaItem)
}

class PlayerManager: NSObject {
    static let shared = PlayerManager()
    weak var delegate : PlayerManagerDelegate?
    /// 播放器
    var audioPlayer : AVAudioPlayer?
    /// 所有音乐列表
    var musics : [MPMediaItem] = []
    /// 当前正在播放的音乐索引
    var playingIndex : NSInteger = 0
    
    var currentTimeString : String {
        get {
            return getTimeString(with: audioPlayer?.currentTime)
        }
    }
    var durationTimeString : String {
        get {
            return getTimeString(with: audioPlayer?.duration)
        }
    }
    var currentTime : Float {
        get {
            return Float(self.audioPlayer?.currentTime ?? 0.0)
        }
    }
    var durationTime : Float {
        get {
            return Float(self.audioPlayer?.duration ?? 0.0)
        }
    }
    
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
        useRemoteControlEvent()
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
    
    /// 根据当播放器的时间转为字符串
    func getTimeString(with timeInterval : TimeInterval?) -> String {
        guard let currentTimeInterval = timeInterval else {
            return kNONE_TIME
        }
        let currentTime = String.tta_string(from: currentTimeInterval, with: "mm:ss")
        return currentTime ?? kNONE_TIME
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
            updateLockScreen()
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
    func previous() {
        var nextIndex = playingIndex - 1
        if nextIndex < 0 {
            nextIndex = musics.count - 1
        }
        print("PreviewMusic")
        play(music : musics[nextIndex])
    }
    /// 切换播放器音乐信息
    func switchPlayerMusicInfo() {
        if let _ = self.delegate?.responds(to: #selector(self.delegate?.playerManager(_:playingMusic:))) {
            self.delegate?.playerManager?(self, playingMusic: musics[playingIndex])
        }
    }
}

// MARK: - RemoteControl
extension PlayerManager {
    func useRemoteControlEvent() {
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            print("RemoteControl Play")
            self.play(music: self.musics[self.playingIndex])
            return MPRemoteCommandHandlerStatus.success
        }
        center.pauseCommand.addTarget(self, action: #selector(pause))
        center.nextTrackCommand.addTarget(self, action: #selector(next))
        center.previousTrackCommand.addTarget(self, action: #selector(previous))
    }
    
    func updateLockScreen() {
        let music = musics[playingIndex]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle : music.title ?? "Music", MPMediaItemPropertyAlbumTitle : music.albumTitle ?? "Playing",MPMediaItemPropertyArtist : music.artist ?? "TTAMusicPlayer",MPMediaItemPropertyPlaybackDuration : music.playbackDuration,MPMediaItemPropertyArtwork : music.artwork ?? MPMediaItemArtwork(image: #imageLiteral(resourceName: "cm2_default_cover_play"))]
    }
}

// MARK: - AVAudioPlayerDelegate
extension PlayerManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }
}
