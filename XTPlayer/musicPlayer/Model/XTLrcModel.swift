//
//  XTLrcModel.swift
//  myPlayer
//
//  Created by victor on 16/11/9.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTLrcModel: NSObject {
    
    var beginTime : TimeInterval = 0
    
    var endTime : TimeInterval = 0
    
    var conent : String = ""
    
    //打印模型中的属性
    override internal var description: String {
        return "beginTime: \(beginTime) \n endTime: \(endTime) \n"
    }
}
