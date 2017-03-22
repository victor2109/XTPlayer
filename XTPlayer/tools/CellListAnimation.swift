//
//  CellListAnimation.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

enum CellListAnimationType {
    case translation /* 平移 */
    case scale /* 缩放 */
    case rotation /* 旋转 */
}

enum AnimationPosition {
    case x
    case y
    case z
}
class CellListAnimation: NSObject {
    
    class func addLayerAnimation(_ layer : CALayer,type : CellListAnimationType, position : AnimationPosition,repertCount : Int, duration : CGFloat) {
        if type == .translation {
            
            let animationPosition = position == .x ? ".x" : ".y"
            //先移除动画
            layer.removeAnimation(forKey: "transform.tranlation" + animationPosition)
            let anmation = CAKeyframeAnimation(keyPath: "transform.translation" + animationPosition)
            anmation.duration = CFTimeInterval(duration)
            anmation.repeatCount = Float(repertCount)
            anmation.values = [-40,0,40]
            layer.add(anmation, forKey: "translation")
        }
        if type == .scale {
            let animationPosition = position == .x ? ".x" : ".y"
            //先移除动画
            layer.removeAnimation(forKey: "transform.scale" + animationPosition)
            let anmation = CAKeyframeAnimation(keyPath: "transform.scale" + animationPosition)
            anmation.duration = CFTimeInterval(duration)
            anmation.repeatCount = Float(repertCount)
            anmation.values = [0.5,1,0.5,1]
            layer.add(anmation, forKey: "scale")
        }
        if type == .rotation {
            var posit : String?
            if position == .x {
                posit = ".x"
            }
            if position == .y {
                posit = ".x"
            }
            if position == .z {
                posit = ".y"
            }
            let animationPosition = posit
            //先移除动画
            layer.removeAnimation(forKey: "transform.rotation" + animationPosition!)
            let anmation = CAKeyframeAnimation(keyPath: "transform.rotation" + animationPosition!)
            anmation.duration = CFTimeInterval(duration)
            anmation.repeatCount = Float(repertCount)
            anmation.values = [-1/6*M_PI,0,1/6*M_PI,0]
            layer.add(anmation, forKey: "rotation")
            
        }
    }
}
