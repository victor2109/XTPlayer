//
//  XTMusic.swift
//  myPlayer
//
//  Created by victor on 16/11/9.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTMusic: NSObject {
    
    /// 歌曲名字
    var name : String?
    
    /// 歌曲路径
    var fileName : String?
    
    /// 歌词名字
    var lrcName : String?
    
    /// 歌手名字
    var singer : String?
    
    /// 歌手图片
    var singerIcon : String?
    
    override init() {
        super.init()
    }
    
    init(dic : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
