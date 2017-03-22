//
//  XTLrcLabel.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTLrcLabel: UILabel {

    // 变色比例
    var radion : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        UIColor.red.set()
        let rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * radion, height: rect.size.height)
        // 控制label变色
        UIRectFillUsingBlendMode(rect, .sourceIn)
    }

}
