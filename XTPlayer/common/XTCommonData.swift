//
//  XTCommonData.swift
//  myPlayer
//
//  Created by victor on 16/11/9.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let MAIN_BOUNDS = UIScreen.main.bounds
let STATUSBAR_HEIGHT = 20.0
let NAVIGATIONBAR_HEIGHT = 44.0

extension UIView {
        
    // 扩展计算属性
    // x坐标
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    
    // y坐标
    var y: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame.origin.y = newValue
        }
    }
    
    /// 右边界的x值
    public var rightX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    /// 下边界的y值
    public var bottomY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    // 宽度
    var width: CGFloat {
        
        get {
            return frame.size.width
        } set {
            frame.size.width = newValue
        }
    }
    // 高度
    var height: CGFloat {
        
        get {
            return frame.size.height
        } set {
            frame.size.height = newValue
        }
    }
    
    // 中心x
    var centerX: CGFloat {
        get {
            return center.x
        } set {
            center.x = newValue
        }
    }
    
    // 中心y
    var centerY: CGFloat {
        get {
            return center.y
        } set {
            center.y = newValue
        }
    }
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
}
