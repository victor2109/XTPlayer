//
//  XTMusicTool.swift
//  myPlayer
//
//  Created by victor on 16/11/9.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit
import AVFoundation
/*
 播放工具类 ：
 */

let kPlayFinishNotification = "kPlayFinishNotification"
class XTMusicTool: NSObject {
    
    var player : AVAudioPlayer?
    
    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            try session.setActive(true)
        } catch {
            print(error)
            return
        }
    }
    
    func playMusicWithName(_ musicName : String) {
        //获取播放路径
        guard  let path = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            return
        }
        
        //如果是正在播放则 return
        if player?.url == path {
            player?.play()
            
            return
        }
        //根据路径创建播放器 因为AVAudioPlayer 需要thorw 穿透
        // AVAudioPlayer 调用，前面必须加try 否则无法编译
        do {
            player = try AVAudioPlayer(contentsOf: path)
            player?.delegate = self
        } catch {
            print(error)
            return
        }
        // 准备播放
        player?.prepareToPlay()
        // 开始播放
        
        player?.play()
    }
    
    /* 暂停 */
    func pauseMusic() {
        player?.pause()
    }
    
    /* 获得当前播放比例 */
    func getCurrnetPlayerPlayRotate() -> CGFloat {
        let rotate = (player?.currentTime)! / (player?.duration)!
        return CGFloat(rotate)
    }
}

extension XTMusicTool : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayFinishNotification), object: self, userInfo: nil)
    }
}
