//
//  XTLrcAddImageTool.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTLrcAddImageTool: NSObject {
    class func addLrcToImage(_ lrc : String?, sourceImage : UIImage?) -> UIImage? {
        guard let image = sourceImage else {return nil}
        guard let resultStr = lrc else {return image}
        //开启图形上下文
        
        let size = image.size
        let screenWidth = size.height - 30
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let strRect = CGRect(x: 0, y:screenWidth, width: size.width, height: 35)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let strDic = [
            NSForegroundColorAttributeName:UIColor.red.cgColor,
            NSFontAttributeName : UIFont.systemFont(ofSize: 16),
            NSParagraphStyleAttributeName : style
            ] as [String : Any]
        (resultStr as NSString).draw(in: strRect, withAttributes: strDic)
        let imagePath = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return imagePath
    }
}
