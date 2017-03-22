//
//  XTLrcTableCell.swift
//  myPlayer
//
//  Created by victor on 16/11/24.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTLrcTableCell: UITableViewCell {
    
    fileprivate let lrcLabel = XTLrcLabel()
    
    var lrcConent : String = "" {
        didSet {
            lrcLabel.text = lrcConent
        }
    }
    
    var progress : CGFloat = 0 {
        didSet {
            lrcLabel.radion = progress
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = UIColor.clear
        
        lrcLabel.frame = CGRect(x: 0, y: 30, width: SCREEN_WIDTH, height: 20)
        lrcLabel.font = UIFont.systemFont(ofSize: 13)
        lrcLabel.textAlignment = .center
        lrcLabel.textColor = UIColor.white
        contentView.addSubview(lrcLabel)
    }

    class func cellWithTableView(_ tableView : UITableView) -> XTLrcTableCell {
        let cellId = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        //Configure the cell...
        if cell == nil {
            cell = XTLrcTableCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        return cell! as! XTLrcTableCell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
