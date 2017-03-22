//
//  XTMusicListTableViewCell.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTMusicListTableViewCell: UITableViewCell {
    
    fileprivate let singerIconImageView = UIImageView()
    fileprivate let songNameLabel = UILabel()
    fileprivate let singerNameLabel = UILabel()
    
    var musicM : XTMusic? {
        didSet {
            singerIconImageView.image = UIImage(named: (musicM?.singerIcon)!)
            songNameLabel.text = musicM?.name
            singerNameLabel.text = musicM?.singer
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = UIColor.clear
        
        singerIconImageView.frame = CGRect(x: 0, y: 8, width: 45, height: 45)
        singerIconImageView.layer.cornerRadius = singerIconImageView.width * 0.5
        singerIconImageView.layer.masksToBounds = true
        contentView.addSubview(singerIconImageView)
        
        songNameLabel.frame = CGRect(x: singerIconImageView.rightX + 16, y: 5, width: SCREEN_WIDTH - 60 - 16, height: 22)
        songNameLabel.font = UIFont.systemFont(ofSize: 18)
        songNameLabel.textColor = UIColor.lightGray
        contentView.addSubview(songNameLabel)
        
        singerNameLabel.frame = CGRect(x: singerIconImageView.rightX + 16, y: 30, width: SCREEN_WIDTH - 60 - 16, height: 18)
        singerNameLabel.font = UIFont.systemFont(ofSize: 15)
        singerNameLabel.textColor = UIColor.lightGray
        contentView.addSubview(singerNameLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWithTableView(_ tableView : UITableView) ->XTMusicListTableViewCell {
        let cellID = "XTMusicList"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? XTMusicListTableViewCell
        if cell == nil {
            cell = XTMusicListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
        }
        return cell!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
