//
//  XTMusicOperationTool.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit
import MediaPlayer

/// 音乐操作队列工具
class XTMusicOperationTool: NSObject {
    
    // 単例
    static let shareInstance = XTMusicOperationTool()
    
    //工具类(播放、暂停、获取当前播放比例)
    let tool : XTMusicTool = XTMusicTool()
    
    var artWork : MPMediaItemArtwork?
    
    /* 上次歌词行号，防止多次加载绘制歌词到图片上 */
    var lastLrcRow = -1
    var musicModel : XTMusicMessageModel = XTMusicMessageModel()
    
    func getMusicMessage() ->XTMusicMessageModel {
        musicModel.modelM = musicsM[currentPlayMusicIndex]
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        musicModel.totalTime = (tool.player?.duration) ?? 0
        musicModel.isPlaying = (tool.player?.isPlaying) ?? false
        return musicModel
    }
    
    /* 列表数组 */
    var musicsM : [XTMusic] = [XTMusic]()
    
    var currentPlayMusicIndex = -1 {
        didSet {
            
            if currentPlayMusicIndex < 0 {
                currentPlayMusicIndex = musicsM.count - 1
            }
            if currentPlayMusicIndex > musicsM.count - 1 {
                currentPlayMusicIndex = 0
            }
        }
    }
    
    /* 播放音乐 */
    func playMusic(_ musics : XTMusic) {
        tool.playMusicWithName(musics.fileName!)
        currentPlayMusicIndex = musicsM.index(of: musics)!
        
        print("当前的播放的是第几首歌曲", (currentPlayMusicIndex))
        
    }
    /* 详情界面调用 播放当前音乐 */
    func playCurrnetMusic () {
        let model = musicsM[currentPlayMusicIndex]
        playMusic(model)
    }
    /* 暂停音乐 */
    func pauseCurrnentMusic() {
        tool.pauseMusic()
    }
    /* 下一首音乐 */
    func nextMusic() {
        /* 下一个数据 */
        currentPlayMusicIndex += 1
        
        //取出数据
        let model = musicsM[currentPlayMusicIndex]
        playMusic(model)
    }
    /* 上一首音乐 */
    func preMusic() {
        /* 上一个数据 */
        currentPlayMusicIndex -= 1
        
        //取出数据
        let model = musicsM[currentPlayMusicIndex]
        playMusic(model)
    }
    /* 设置播放比例是多少 */
    func setPlayerPlayRotate(_ progress : CGFloat) {
        if tool.getCurrnetPlayerPlayRotate() == progress {
            return
        }
        let duration = tool.player?.duration
        tool.player?.currentTime = TimeInterval(progress) * duration!
    }
}
/* 锁屏解密通信 */
//extension XTMusicOperationTool {
//    
//    func setUpLocakMessage() {
//        /* 可以不将歌词添加到图片 */
//        let socket = true
//        let message = getMusicMessage()
//        let mediaCenter = MPNowPlayingInfoCenter.default()
//        
//        //标题
//        let title = message.modelM?.name ?? ""
//        let singerName = message.modelM?.singer ?? ""
//        
//        let costTime = message.costTime
//        let totalTime = message.totalTime
//        let iconName = message.modelM?.singerIcon ?? ""
//        
//        //获取歌词
//        let lrcName = message.modelM?.lrcName
//        let lrcMs = XTMusicDataTool.getLrcMS(lrcName: lrcName)
//        let lrcM = XTMusicDataTool.getCurrntLrcModel(currentTime: message.costTime, lrcModel: lrcMs).model
//        let lrcRow = XTMusicDataTool.getCurrntLrcModel(currentTime: message.costTime, lrcModel: lrcMs).row
//        var image = UIImage(named: iconName)
//        
//        var dic : [String : Any] = [
//            MPMediaItemPropertyTitle : title,
//            MPMediaItemPropertyArtist : singerName,
//            MPMediaItemPropertyPlaybackDuration : totalTime,
//            MPNowPlayingInfoPropertyElapsedPlaybackTime : costTime,
//            ]
//        if socket && lrcRow != lastLrcRow && image != nil {
//            lastLrcRow = lrcRow
//            image = XTLrcAddImageTool.addLrcToImage(lrc: lrcM?.conent, sourceImage: image)
//            if image != nil {
//                artWork = MPMediaItemArtwork(image: image!)
//            }
//            
//        }
//        if artWork != nil {
//            dic[MPMediaItemPropertyArtwork] = artWork
//        }
//        mediaCenter.nowPlayingInfo = dic
//        
//        //开始接受远程事件
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//    }
//}
