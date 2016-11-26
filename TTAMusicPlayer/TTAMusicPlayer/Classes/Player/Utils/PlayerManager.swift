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
let kNOW_PLAYING_MUSIC_INFO = "NowPlayingMusicInfo"
let kNOW_PLAYING_MUSIC_URL = "NowPlayingMusicURL"

@objc protocol PlayerManagerDelegate : NSObjectProtocol {
    @objc optional func playerManager(_ playerManager : PlayerManager, playingMusic : MPMediaItem)
    @objc optional func playerManagerUpdateProgressAndTime(_ playerManager : PlayerManager)
    @objc optional func playerManager(_ playerManager : PlayerManager, conrtolMusicIconAnimation isPause : Bool)
}

class PlayerManager: NSObject {
    static let shared = PlayerManager()
    weak var delegate : PlayerManagerDelegate? {
        didSet { // 这里要先将之前的一个计时器停掉,不然的切换音乐后,进入界面后不会更新进度条与播放时间
            stopTimer()
            startTimer()
            controlMusicIconAnimation(with: false)
        }
    }
    /// 播放器
    var audioPlayer : AVAudioPlayer?
    /// 所有音乐列表
    var musics : [MPMediaItem] = []
    /// 当前正在播放的音乐索引
    var playingIndex : Int = 0
    
    var timer : Timer?
    
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
        set {
            self.audioPlayer?.currentTime = TimeInterval(newValue)
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
            updateLockScreen(with: 1.0)
            saveNowPlayingMusicInfo(with: playingIndex, url: musicURL)
        }
        controlMusicIconAnimation(with: false)
        audioPlayer?.play()
        startTimer()
        print("PlayMusic: \(music.title!)")
    }
    func play(musicURL : URL) {
        var nowPlayMusic : MPMediaItem? = MPMediaItem()
        if musicURL != audioPlayer?.url {
            audioPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            for (index, music) in musics.enumerated() {
                if let assetURL = music.assetURL, assetURL == musicURL {
                    self.playingIndex = index
                    nowPlayMusic = music
                    break
                }
            }
            switchPlayerMusicInfo()
            updateLockScreen(with: 1.0)
            saveNowPlayingMusicInfo(with: playingIndex, url: musicURL)
        }
        controlMusicIconAnimation(with: false)
        audioPlayer?.play()
        startTimer()
        print("PlayMusicURL: \(musicURL), Music: \(nowPlayMusic?.title ?? "未命名歌曲")")
    }
    
    /// 暂停
    func pause() {
        if let _ = audioPlayer?.isPlaying {
            updateLockScreen(with: 0.0)
            controlMusicIconAnimation(with: true)
            audioPlayer?.pause()
            stopTimer()
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
    /// 控制音乐图片的转动动画
    func controlMusicIconAnimation(with isPause : Bool) {
        if let _ = delegate?.responds(to: #selector(delegate?.playerManager(_:conrtolMusicIconAnimation:))) {
            delegate?.playerManager?(self, conrtolMusicIconAnimation: isPause)
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
    
    /// 更新锁屏界面信息
    ///
    /// - Parameter rate: 播放速率,1.0 为正常播放, 0.0 为暂停
    func updateLockScreen(with rate : Float) {
        let music = musics[playingIndex]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle : music.title ?? "Music", MPMediaItemPropertyAlbumTitle : music.albumTitle ?? "Playing",MPMediaItemPropertyArtist : music.artist ?? "TTAMusicPlayer",MPMediaItemPropertyPlaybackDuration : (music.playbackDuration),MPNowPlayingInfoPropertyElapsedPlaybackTime : (currentTime),MPNowPlayingInfoPropertyPlaybackRate :  rate, MPMediaItemPropertyArtwork : music.artwork ?? MPMediaItemArtwork(image: #imageLiteral(resourceName: "cm2_default_cover_play"))]
    }
}

// MARK: - Timer
extension PlayerManager {
    func startTimer() {
        guard timer == nil else {
            return
        }
        guard delegate != nil else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateRemoteInfoWithTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateRemoteInfoWithTimer() {
        updateLockScreen(with: 1.0)
        if let _ = self.delegate?.responds(to: #selector(self.delegate?.playerManagerUpdateProgressAndTime(_:))) {
            self.delegate?.playerManagerUpdateProgressAndTime?(self)
        }
    }
}

// MARK: - Save and read now playing music url in user default
extension PlayerManager {
    func readNowPlayingMusicInfo() -> URL {
        if let userDefault = UserDefaults.standard.object(forKey: kNOW_PLAYING_MUSIC_INFO) as? [String : String] {
            guard let urlString = userDefault[kNOW_PLAYING_MUSIC_URL] else { return musics[0].assetURL!}
            return URL(string: urlString)!
        }
        return musics[0].assetURL!
    }
    
    func saveNowPlayingMusicInfo(with musicIndex : Int, url: URL) {
        let nowPlayingMusicInfoDic = [kNOW_PLAYING_MUSIC_URL : String(describing: url)]
        UserDefaults.standard.set(nowPlayingMusicInfoDic, forKey: kNOW_PLAYING_MUSIC_INFO)
    }
}

// MARK: - AVAudioPlayerDelegate
extension PlayerManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }
}
