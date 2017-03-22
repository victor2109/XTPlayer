//
//  XTMusicDataTool.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTMusicDataTool: NSObject {
    
    class func getMusicMs(_ result : ([XTMusic]) -> ()) {
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([XTMusic]())
            return
        }
        
        // 获取文件内容
        guard let array = NSArray(contentsOfFile: path) else {
            result([XTMusic]())
            return
        }
        
        // 文件解析
        var models = [XTMusic]()
        for dic in array {
            let model = XTMusic(dic: dic as! [String : AnyObject])
            models.append(model)
        }
        result(models)
    }
    
    /* 获得所有歌词模型 */
    class func getLrcMS(_ lrcName : String?) -> ([XTLrcModel]) {
        if lrcName == nil {
            return [XTLrcModel]()
        }
        // 1 读取文件的路径
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil)
            else {
            return  [XTLrcModel]()
        }
        
        // 2 读取文件中的内容呢
        var lrcConent = ""
        do {
            lrcConent = try String(contentsOfFile: path)
        } catch {
            print(error)
            return [XTLrcModel]()
        }
        
        // 3 解析字符串
        var resultArray = [XTLrcModel]()
        let conentArray = lrcConent.components(separatedBy: "\n")
        for  var conentString in conentArray {
            if conentString.contains("[ti:") || conentString.contains("[ar:") || conentString.contains("[t_time:"){
                continue
            }
            //删除第一个括号
            conentString = conentString.replacingOccurrences(of: "[", with: "")
            let detailArray = conentString.components(separatedBy: "]")
            if detailArray.count != 2 {
                continue
            }
            let startTime = XTTimeTool.getFormatTimeToTimeInval(detailArray[0])
            var content = detailArray[1]
            
            content = content.replacingOccurrences(of: "\r", with: "")
            let model = XTLrcModel()
            resultArray.append(model)
            model.beginTime = startTime
            model.conent = content
        }
        
        //遍历resultArray 第二个参数的开始时间是第一个的结束时间
        let count = resultArray.count
        for rs in 0..<count {
            
            if rs == count - 1 {
                break
            }
            let lrcM = resultArray[rs]
            let nextLrcM = resultArray[rs + 1]
            lrcM.endTime = nextLrcM.beginTime
        }
        
        return resultArray
    }
    /* 获取当前播放的歌词模型 */
    class func getCurrntLrcModel (_ currentTime : TimeInterval, lrcModel : [XTLrcModel]) -> ( row : Int , model : XTLrcModel?) {
        
        var index = 0
        for lrcM in lrcModel {
            
            if lrcM.endTime >= currentTime && lrcM.beginTime <= currentTime {
                
                return (index, lrcM)
            }
            index += 1
        }
        return (0,nil)
    }
}
