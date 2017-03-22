//
//  CALayer+Animation.swift
//  myPlayer
//
//  Created by victor on 16/11/23.
//  Copyright © 2016年 victor. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    /// 暂停动画
    func pauseAnimation() {
        let pauseTime : CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
    
    /// 继续动画
    func resumeAnimation() {
        let pauseTime : CFTimeInterval = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause : CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        beginTime = timeSincePause
    }
}
