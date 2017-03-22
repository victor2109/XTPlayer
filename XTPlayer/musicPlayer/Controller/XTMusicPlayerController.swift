//
//  XTMusicPlayerController.swift
//  myPlayer
//
//  Created by victor on 16/11/9.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit
import AVFoundation

class XTMusicPlayerController: UIViewController {

    lazy var backImageView : UIImageView = UIImageView()    //背景图片
    lazy var foreImgView : UIImageView = UIImageView() //旋转图片
    lazy var bottomView : UIView = UIView()    //底部控制器的view
    lazy var songLabel : UILabel = UILabel()    //歌曲名称
    lazy var singerLabel : UILabel = UILabel()  //歌手名
    lazy var singerIcon : UIImageView = UIImageView() //歌手封面
    lazy var exitBtn : UIButton = UIButton()        // 退出播放页按钮
    
    lazy var costTimerLabel : UILabel = UILabel()   //当前播放时间
    lazy var progressSlider : UISlider = UISlider() //进度条
    lazy var totalTimeLabel : UILabel = UILabel() //音乐总时长
    lazy var playOrPauseBtn : UIButton = UIButton()  //播放或暂停按钮
    lazy var previousBtn : UIButton = UIButton()     //上一首
    lazy var nextBtn : UIButton = UIButton()       //下一首
    
    lazy var lrcView : UIView = UIView()           //歌词的
    var currentProgress : CGFloat?              //当前播放比例
    lazy var lrcScrollView : UIScrollView = UIScrollView() //歌词scrollView
    lazy var lrcLabel : XTLrcLabel = XTLrcLabel()   //单行歌词 n
    
    var timer : Timer?                        //定时器
    var updateLrcLink : CADisplayLink?          //歌词定时器
    
    // 歌词控制器
    lazy var lrcVC : XTLrcVC = {
       return XTLrcVC()
    }()
    var player : AVAudioPlayer? = AVAudioPlayer()      //播放器
    var playingMusic : XTMusic?    //记录正在播放的音乐
    
    
    fileprivate func setupUI() {
        
        backImageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        backImageView.image = UIImage(named: "timg")
        backImageView.isUserInteractionEnabled = true
        view.addSubview(backImageView)
        
        exitBtn = UIButton(type: .custom)
        exitBtn.frame = CGRect(x: 10, y: 30, width: 50, height: 50)
        exitBtn.setImage(UIImage(named: "mmd"), for: .normal)
        exitBtn.addTarget(self, action: #selector(backToListVC), for: .touchUpInside)
        view.addSubview(exitBtn)
        
        songLabel.frame = CGRect(x: (SCREEN_WIDTH - 100) / 2, y: 25, width: 100, height: 21)
        songLabel.font = UIFont.systemFont(ofSize: 17)
        songLabel.textAlignment = .center
        view.addSubview(songLabel)
        
        singerLabel.frame = CGRect(x: (SCREEN_WIDTH - 100) / 2, y: 61, width: 100, height: 17)
        singerLabel.font = UIFont.systemFont(ofSize: 14)
        singerLabel.textAlignment = .center
        view.addSubview(singerLabel)
        
        foreImgView.frame = CGRect(x: 75, y: 101, width: 225, height: 225)
        foreImgView.image = UIImage(named: "photo")
        view.addSubview(foreImgView)
        
        lrcLabel.frame = CGRect(x: 0, y: foreImgView.bottomY + 15, width: SCREEN_WIDTH, height: 19)
        lrcLabel.textAlignment = .center
        lrcLabel.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(lrcLabel)
        
        //底部工具条视图
        bottomView.frame = CGRect(x: 0, y: view.height - 120, width: view.width, height: 120)
        bottomView.backgroundColor = UIColor.clear
        view.addSubview(bottomView)
        
        setupBottomUI()
    }
    
    /// 底部视图
    fileprivate func setupBottomUI() {
        
        costTimerLabel.frame = CGRect(x: 15, y: 19, width: 60, height: 14)
        costTimerLabel.text = "00:00"
        costTimerLabel.font = UIFont.systemFont(ofSize: 11)
        bottomView.addSubview(costTimerLabel)
        
        progressSlider.frame = CGRect(x: costTimerLabel.rightX + 20, y: 10, width: 200, height: 31)
        bottomView.addSubview(progressSlider)
        
        totalTimeLabel.frame = CGRect(x: progressSlider.rightX + 20, y: 19, width: 60, height: 14)
        totalTimeLabel.text = "00:00"
        totalTimeLabel.font = UIFont.systemFont(ofSize: 11)
        bottomView.addSubview(totalTimeLabel)
        
        playOrPauseBtn.frame = CGRect(x: 0, y: bottomView.height - 80 - 10, width: 80, height: 80)
        playOrPauseBtn.centerX = bottomView.centerX
        playOrPauseBtn.setImage(UIImage.init(named: "play"), for: .normal)
        playOrPauseBtn.setImage(UIImage.init(named: "pause"), for: .selected)
        playOrPauseBtn.addTarget(self, action: #selector(playOrPauseClick), for: .touchUpInside)
        bottomView.addSubview(playOrPauseBtn)
        
        previousBtn.frame = CGRect(x: playOrPauseBtn.x - 20 - 52, y: 0, width: 52, height: 52)
        previousBtn.centerY = playOrPauseBtn.centerY
        previousBtn.setImage(UIImage.init(named: "upSinger"), for: .normal)
        previousBtn.addTarget(self, action: #selector(previousClick), for: .touchUpInside)
        bottomView.addSubview(previousBtn)
        
        nextBtn.frame = CGRect(x: playOrPauseBtn.rightX + 20, y: 0, width: previousBtn.width, height: previousBtn.height)
        nextBtn.centerY = playOrPauseBtn.centerY
        nextBtn.setImage(UIImage.init(named: "nextSinger"), for: .normal)
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        bottomView.addSubview(nextBtn)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: 界面
extension XTMusicPlayerController {
    
    /* scrollerView设置大小 */
    fileprivate func setUpScrollerView(frame : CGRect) {
        lrcScrollView.contentSize = CGSize(width: frame.width * 2, height: 0)
    }
    /* scrollerView添加View */
    fileprivate func addLrcView() {
        
        lrcVC.tableView.backgroundColor = UIColor.clear
        lrcScrollView.frame = CGRect(x: 0, y: 120, width: SCREEN_WIDTH, height: 427)
        lrcScrollView.backgroundColor = UIColor.clear
        lrcScrollView.addSubview(lrcVC.tableView)
        lrcScrollView.isPagingEnabled = true
        lrcScrollView.showsHorizontalScrollIndicator = false
        lrcScrollView.delegate = self
        backImageView.addSubview(lrcScrollView)
    }
    
    fileprivate func setUpLrcView() {
        let frame = lrcScrollView.bounds
        lrcVC.tableView.frame = frame
        lrcVC.tableView.x = frame.width
        setUpScrollerView(frame: frame)
        setUpImageView()
    }
    
    /// 设置图片圆形
    fileprivate func setUpImageView() {
        foreImgView.layer.cornerRadius = foreImgView.width * 0.5
        foreImgView.layer.masksToBounds = true
    }
    
    
    func setUpProgressSlider() {
        
        progressSlider.setThumbImage(UIImage(named:"progressSlider"), for: .normal)
        
        progressSlider.addTarget(self, action: #selector(touchProgressSlider(str:)), for: .touchUpInside)
//        progressSlider.addTarget(self, action: #selector(progressSliderValue(str:)), for: .allTouchEvents)
        
    }
    
    func changePlayingStatus() {
        let bool = (XTMusicOperationTool.shareInstance.tool.player?.isPlaying)! as Bool
        self.playOrPauseBtn.isSelected = bool
        
    }
    
    @objc fileprivate func progressSliderValue(str : UISlider) {
        
//        let tine =  XTMusicOperationTool.shareInstance.tool.player?.currentTime
//        print(tine);
//        let rotate = str.value
//        print(rotate)
    }
    
    @objc fileprivate func touchProgressSlider(str: UISlider) {
        print("开始点击")
        self.progressSlider.value = str.value
        XTMusicOperationTool.shareInstance.setPlayerPlayRotate(CGFloat(self.progressSlider.value))
    }
    
    // 更新歌词
    func updateLrc() {
        
        let message =  XTMusicOperationTool.shareInstance.getMusicMessage()
        let arr = lrcVC.lrcMs
        
        let lrcModel = XTMusicDataTool.getCurrntLrcModel(message.costTime, lrcModel: arr)
        
        lrcLabel.text = lrcModel.model?.conent
        //获取当前行号
        let row = lrcModel.row
        
        lrcVC.scrollRow = row
        
        /* 设置歌词进度 */
        if lrcModel.model != nil {
            let  time1 =  (message.costTime - lrcModel.model!.beginTime)
            let time2 = lrcModel.model!.endTime - lrcModel.model!.beginTime
            lrcLabel.radion = CGFloat(time1 / time2)
            lrcVC.progressLrc = lrcLabel.radion
        }
        let status = UIApplication.shared.applicationState
        if status == .background {
//            XTMusicOperationTool.shareInstance.setUpLocakMessage()
        }
    }
}

//MARK:业务逻辑
extension XTMusicPlayerController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        addLrcView()
        setUpProgressSlider()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(nextClick), name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpLrcView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        setUpKitOnceData()
        addDisplayLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeDisPlayLink()
    }
    
    /// 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 返回歌曲库
    // 设为私有方法后，如果想调用方法，前面要加@objc

    @objc fileprivate func backToListVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // 开始播放or暂停
    @objc fileprivate func playOrPauseClick(_ sender: AnyObject) {
        let button : UIButton = sender as! UIButton
        button.isSelected = !sender.isSelected
        
        if button.isSelected {
            self.resumeForeImageViewAnimation()
            XTMusicOperationTool.shareInstance.playCurrnetMusic()
            updateLrcLink?.isPaused = false
        } else {
            self.pauseForeImageViewAnimation()
            XTMusicOperationTool.shareInstance.pauseCurrnentMusic()
            updateLrcLink?.isPaused = true
        }
    }
    
    /* 上一首 */
    @objc fileprivate func previousClick() {
        updateLrcLink?.isPaused = false
        XTMusicOperationTool.shareInstance.preMusic()
        setUpKitOnceData()
    }
    
    /* 下一首 */
    @objc fileprivate func nextClick() {
        updateLrcLink?.isPaused = false
        XTMusicOperationTool.shareInstance.nextMusic()
        setUpKitOnceData()
    }
}

//MARK:做动画
extension XTMusicPlayerController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let p = 1 - offsetX / scrollView.width
        lrcLabel.alpha = p
        foreImgView.alpha = p
    }
    /* 前置图片添加动画 */
    func addForeImageViewAddAnimation() {
        foreImgView.layer.removeAnimation(forKey: "foreImageViewRotationAnimation")
        let anaimation = CABasicAnimation(keyPath: "transform.rotation.z")
        anaimation.fromValue = 0
        anaimation.toValue = M_PI * 2
        anaimation.duration = 10
        anaimation.repeatCount = MAXFLOAT
        anaimation.isRemovedOnCompletion = false//退出界面要不要停止动画
        foreImgView.layer.add(anaimation, forKey: "foreImageViewRotationAnimation")
    }
    /* 暂停旋转动画 */
    func pauseForeImageViewAnimation() {
        foreImgView.layer.pauseAnimation()
    }
    
    func resumeForeImageViewAnimation() {
        foreImgView.layer.resumeAnimation()
    }
}

// MARK: - 数据赋值
extension XTMusicPlayerController {
    /* 一次赋值 */
    func setUpKitOnceData() {
        
        let message = XTMusicOperationTool.shareInstance.getMusicMessage()
        
        guard message.modelM != nil else {
            return
        }
        
        if message.modelM?.singerIcon != nil {
            backImageView.image = UIImage(named: "play_cover_pic_bg")
            /* 展示的图片 1*/
            foreImgView.image = UIImage(named: (message.modelM?.singerIcon)!)
        }
        
        /* 歌名 */
        songLabel.text = message.modelM?.name
        /* 歌手名字 */
        singerLabel.text = message.modelM?.singer
        
        /* 总时长 */
        totalTimeLabel.text = XTTimeTool.getFormatTime(message.totalTime)
        
        /* 获取歌词 */
        let lrcArr = XTMusicDataTool.getLrcMS(message.modelM?.lrcName)
        /* 将歌词数组给lrcVC界面 数组 */
        self.lrcVC.lrcMs = lrcArr
        
        addForeImageViewAddAnimation()
        
        let bool = (XTMusicOperationTool.shareInstance.tool.player?.isPlaying)! as Bool
        if bool {
            resumeForeImageViewAnimation()
        } else {
            pauseForeImageViewAnimation()
        }
    }
    /* 多次赋值 */
    func setUpKitTimesData() {
        
        let message =  XTMusicOperationTool.shareInstance.getMusicMessage()
        
        /* 进度条 */
        progressSlider.value = Float(message.costTime / message.totalTime)
        /* 当前播放时间 */
        costTimerLabel.text = XTTimeTool.getFormatTime(message.costTime)
        changePlayingStatus()
    }
    
    /* 添加定时器 */
    func addTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(setUpKitTimesData), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    /* 移除定时器 */
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /* 添加歌词定时器 */
    func addDisplayLink() {
        updateLrcLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        updateLrcLink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    /* 移除歌词定时器 */
    func removeDisPlayLink() {
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }
}

//MARK: 远程监听事件
extension XTMusicPlayerController {
    override func remoteControlReceived(with event: UIEvent?) {
        let type = event?.subtype
        // type 不进行解包的话，枚举是敲不出来的
        switch type! {
        case .remoteControlPlay:
            XTMusicOperationTool.shareInstance.playCurrnetMusic()
            print("play")
            
        case .remoteControlPause:
            XTMusicOperationTool.shareInstance.pauseCurrnentMusic()
            print("pause")
            
        case .remoteControlNextTrack:
            XTMusicOperationTool.shareInstance.nextMusic()
            print("next")
            
        case .remoteControlPreviousTrack:
            XTMusicOperationTool.shareInstance.preMusic()
            print("pre")
            
        default:
            print("play - 1")
        }
        setUpKitOnceData()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        XTMusicOperationTool.shareInstance.nextMusic()
        setUpKitOnceData()
    }
}
