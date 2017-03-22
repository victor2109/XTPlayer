//
//  XTMusciListController.swift
//  myPlayer
//
//  Created by victor on 16/11/9.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class XTMusciListController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var musicsMs : [XTMusic] = [XTMusic]() {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView : UITableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "音乐库"
        
        setUp()
        
        XTMusicDataTool.getMusicMs { (models : [XTMusic]) in
            musicsMs = models
            // 获取数据赋值
            XTMusicOperationTool.shareInstance.musicsM = models
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - 处理界面
extension XTMusciListController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setUp() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 61.0
        tableView.separatorStyle = .none
        tableView.backgroundView = UIImageView(image:UIImage(named: "QQLiseBack"))
        view.addSubview(tableView)
    }
    
    // MARK: tableView数据源方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicsMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = XTMusicListTableViewCell.cellWithTableView(tableView)
        
        cell.musicM = musicsMs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let muscis = musicsMs[indexPath.row]
            XTMusicOperationTool.shareInstance.playMusic(muscis)
        
            let playC = XTMusicPlayerController()
            playC.playingMusic = musicsMs[indexPath.row]
            navigationController?.pushViewController(playC, animated: true)
        
    }
}
