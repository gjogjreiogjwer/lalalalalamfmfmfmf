//
//  TimerController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/7.
//

import UIKit
import AVFoundation
import KDCircularProgress


protocol TimerDelegate {
    func didUpdateTime(time:Int)
}


class TimerController: UIViewController {
    
    var time = 0.0
    var delegate:TimerDelegate?
    
    private var timer = Timer()
    private var isCounting = false
    private var i = 0
    private let themeArr = ["Spring", "Summer", "Autumn", "Winter"]
    private var player:AVAudioPlayer?
    private var originButtonColor:UIColor!
    private var unEnabledButtonColor:UIColor!
    private var progress:KDCircularProgress!
    
    static var timerStyle = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteBotton: UIBarButtonItem!
    @IBOutlet weak var background: UIImageView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fixed in daytime mode
        overrideUserInterfaceStyle = .light
        
        timeLabel.text = String(time)
        
        originButtonColor = startButton.currentTitleColor
        unEnabledButtonColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        pauseButton.isEnabled = false
        pauseButton.setTitleColor(unEnabledButtonColor, for: UIControl.State.normal)
        muteBotton.isEnabled = false
        background.alpha = 0.3
        
        progressInit()
        
        TimerController.timerStyle = UserDefaults.standard.integer(forKey: "style")
        print(TimerController.timerStyle)
        
        if TimerController.timerStyle == 1{
            startButton.isHidden = true
            pauseButton.isHidden = true
            
            //开启距离传感器功能
            UIDevice.current.isProximityMonitoringEnabled = true
           //监听物体开进或离开设备的通知
           NotificationCenter.default.addObserver(self, selector:#selector(statusChange), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent{
            if let player = player{
                if player.isPlaying{
                    player.stop()
                }
            }
        }
    }
    
    private func progressInit(){
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progress.startAngle = -90
        progress.progressThickness = 0.1
        progress.trackThickness = 0.2
        progress.gradientRotateSpeed = 2
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: UIColor.cyan ,UIColor.white)
        progress.trackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        progress.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(progress)
    }
    
    
    // MARK: - Timer
    
    @objc func UpdateTimer() {
        time -= 0.1
        if time <= 0.001{
            timer.invalidate()
            timeLabel.text = "0.0"
            pauseButton.isEnabled = false
            pauseButton.setTitleColor(unEnabledButtonColor, for: UIControl.State.normal)
        }
        else{
            timeLabel.text = String(format: "%.1f", time)
        }
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        start()
    }
    
    private func start(){
        if(isCounting) {
            return
        }
        startButton.isEnabled = false
        startButton.setTitleColor(unEnabledButtonColor, for: UIControl.State.normal)
        pauseButton.isEnabled = true
        pauseButton.setTitleColor(originButtonColor, for: UIControl.State.normal)
            
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimerController.UpdateTimer), userInfo: nil, repeats: true)
        isCounting = true
        
        progress.animate(fromAngle: progress.angle, toAngle: 360, duration: time) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
    }
    
    
    @IBAction func pauseTimer(_ sender: Any) {
        pause()
    }
    
    private func pause(){
        startButton.isEnabled = true
        startButton.setTitleColor(originButtonColor, for: UIControl.State.normal)
        pauseButton.isEnabled = false
        pauseButton.setTitleColor(unEnabledButtonColor, for: UIControl.State.normal)
            
        timer.invalidate()
        isCounting = false
        
        progress.pauseAnimation()
    }
    
    
    // MARK: - Actions
    
    @IBAction func done(_ sender: Any) {
        delegate?.didUpdateTime(time: Int(time))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mute(_ sender: Any) {
        if player!.isPlaying{
            player!.stop()
            muteBotton.image = UIImage(systemName: "speaker.wave.3")
        }
        else{
            player!.play()
            muteBotton.image = UIImage(systemName: "speaker.slash")
        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        muteBotton.isEnabled = true
        muteBotton.image = UIImage(systemName: "speaker.slash")
        changeTheme()
        changeMusic()
        changeBackground()
        i = i >= themeArr.count-1 ? 0 : i+1
    }
    
    
    private func changeTheme(){
        let themeLabel = UILabel()
//        themeLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        themeLabel.layer.cornerRadius = 5.0
        themeLabel.font = UIFont.systemFont(ofSize: 30)
        themeLabel.adjustsFontSizeToFitWidth=true
        themeLabel.text = "Theme: \(themeArr[i])"
        view.addSubview(themeLabel)
        
        themeLabel.frame.size.width = 300
        themeLabel.frame.size.height = 100
        themeLabel.center.x = view.center.x
        themeLabel.center.y = view.frame.height + 50
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        themeLabel.frame.size.width = 600
                        themeLabel.frame.size.height = 100
                        themeLabel.center.x = self.view.frame.width - 10
                        themeLabel.center.y -= 150
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       options: .curveEaseIn) {
            themeLabel.frame.size.width = 300
            themeLabel.frame.size.height = 100
            themeLabel.center.x = self.view.frame.width
            themeLabel.center.y = self.view.frame.height + 50
        } completion: { _ in
            themeLabel.removeFromSuperview()
        }
    }
    
    
    private func changeMusic(){
        let url = Bundle.main.url(forResource: themeArr[i], withExtension: "mp3")
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player!.numberOfLoops = -1
            player!.play()
        }catch{
            print(error)
        }
    }
    
    
    private func changeBackground(){
//        background.image = UIImage(named: themeArr[i])
        let temp = UIImageView(frame: background.frame)
        temp.contentMode = .scaleAspectFill
        temp.image = UIImage(named: themeArr[i])
        temp.transform = CGAffineTransform(translationX: 100, y: 0)
        temp.alpha = 0
        view.insertSubview(temp, aboveSubview: background)
        
        UIView.animate(withDuration: 0.5) {
            self.background.transform = CGAffineTransform(translationX: 100, y: 0)
            self.background.alpha = 0
            temp.alpha = 0.3
            temp.transform = .identity
        } completion: { _ in
            self.background.image = temp.image
            self.background.alpha = 0.3
            self.background.transform = .identity
            temp.removeFromSuperview()
        }
    }
    
    
    // MARK: - distance sentor
    
    /// 这个主要在 手机上方，电话听筒有相应  = =  下面没得反应
    @objc func statusChange(){
        //获取当前是否有物体靠近设备
        if UIDevice.current.proximityState {
            //靠近了
            start()
            print("靠近了")
        }else{
            //远离了
            pause()
            print("远离了")
        }
    }
}
