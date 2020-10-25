//
//  TimerController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/7.
//

import UIKit
import AVFoundation
import KDCircularProgress
import Speech
import Alamofire
import SwiftyJSON

protocol TimerDelegate {
    func didUpdateTime(time:Int)
}


class TimerController: UIViewController {
    
    var time = 0.0
//    private var learningTime = 0.0
    var delegate:TimerDelegate?
    
    private var timer = Timer()
    private var learningTime = 0.0
    private var isCounting = false
    private var i = 0
    private let themeArr = ["Spring", "Summer", "Autumn", "Winter"]
    private var player:AVAudioPlayer?
    private var originButtonColor:UIColor!
    private var unEnabledButtonColor:UIColor!
    private var progress:KDCircularProgress!
    private var textView: UITextView?
//    private let speakSentence = "I am your father"
    private var flag = false
    private var microOpen = false
    private var audioSession: AVAudioSession?
    private var quote = "Stop"
    private let quoteURL = "http://api.cervidae.com.au:8080/quotes"
    private let updateURL = "http://api.cervidae.com.au:8080/users/"
    
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    static var timerStyle = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteBotton: UIBarButtonItem!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSession = AVAudioSession.sharedInstance()
        
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
        
        if TimerController.timerStyle == 2{
            getQuote()
        }
        
        
        if TimerController.timerStyle == 1{
            startButton.isHidden = true
            pauseButton.isHidden = true
            
            //开启距离传感器功能
            UIDevice.current.isProximityMonitoringEnabled = true
           //监听物体开进或离开设备的通知
           NotificationCenter.default.addObserver(self, selector:#selector(statusChange), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        }
        
        pauseButton.isEnabled = false
        SFSpeechRecognizer.requestAuthorization { (status) in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized: self.pauseButton.isEnabled = true
                default: self.pauseButton.isEnabled = false
                }
            }
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
    
    
    private func getQuote(){
        AF.request(quoteURL, method: .get).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                let temp = message["payload", "quote"].stringValue
                print(temp)
//                self.quote = temp[1..<temp.count-1]
                self.quote = temp
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
        learningTime += 0.1
        if time <= 0.001{
            timer.invalidate()
            timeLabel.text = "0.0"
            pauseButton.isEnabled = false
            doneButton.isEnabled = true
            pauseButton.setTitleColor(unEnabledButtonColor, for: UIControl.State.normal)
            changeMusic(musicFile: "Done", loop: 0)
            
            
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
        doneButton.isEnabled = false
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
        if TimerController.timerStyle == 2{
            if let player = player{
                if player.isPlaying{
                    player.pause()
                    flag = true
                }
            }
            startButton.isHidden = true
            muteBotton.isEnabled = false
            microphoneStyle()
        }
    }
    
    
    private func pause(){
        doneButton.isEnabled = true
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
        LoginController.currentScore += learningTime
        let paras = ["newScore": String(Int(LoginController.currentScore))]
        AF.request(updateURL, method: .post, parameters: paras).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                if message["success"] == 1{
                    print("update success")
                }
                else{
                    print("update error")
                }
            }
        }
        
        delegate?.didUpdateTime(time: Int(time))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mute(_ sender: Any) {
        if player!.isPlaying{
            player!.pause()
            muteBotton.image = UIImage(systemName: "speaker.wave.3")
        }
        else{
            player!.play()
            muteBotton.image = UIImage(systemName: "speaker.slash")
        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if !microOpen{
            muteBotton.isEnabled = true
            muteBotton.image = UIImage(systemName: "speaker.slash")
            changeTheme()
            changeMusic(musicFile: themeArr[i], loop: -1)
            changeBackground()
            i = i >= themeArr.count-1 ? 0 : i+1
        }
        
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
    
    
    private func changeMusic(musicFile: String, loop: Int){
        let url = Bundle.main.url(forResource: musicFile, withExtension: "mp3")
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player!.numberOfLoops = loop
            player!.prepareToPlay()
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
    
    
    
    // MARK: - Microphone style
    
    private func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            pauseButton.isEnabled = true
        } else {
            pauseButton.isEnabled = false
        }
    }
    
    
    private func microphoneStyle(){
        if audioEngine.isRunning {
            microOpen = false
            request?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            //category切换回音乐模式
            try? audioSession!.setCategory(AVAudioSession.Category.playback)
            //mode从micro的最小化改成扬声器
            try? audioSession!.setMode(AVAudioSession.Mode.moviePlayback)
            if let textView = textView{
                doneButton.isEnabled = true
                pauseButton.setTitle("Pause", for: .normal)
                startButton.isHidden = false
                if textView.text != quote{
                    start()
                }
                textView.removeFromSuperview()
                if let player = player{
                    muteBotton.isEnabled = true
                    if flag{
                        player.play()
                        flag = false
                    }
                }
            }
            getQuote()
        }
        else {
            createTextView()
            microOpen = true
            pauseButton.isEnabled = true
            pauseButton.setTitleColor(originButtonColor, for: UIControl.State.normal)
            pauseButton.setTitle("Stop Recording", for: .normal)
            doneButton.isEnabled = false
            startDictation()
        }
    }
    
    
    private func createTextView(){
        textView = UITextView()
        textView!.layer.cornerRadius = 5.0
        textView!.font = UIFont.systemFont(ofSize: 25)
        textView!.frame.size.width = view.frame.width - 20
        textView!.frame.size.height = 120
        textView!.center.x = view.center.x
        textView!.center.y = view.center.y - 210
        textView!.alpha = 0.5
        textView!.text = """
            Please say the following sentence:
            \(quote)
            """
        textView!.textAlignment = .center
        view.addSubview(textView!)
    }
    
    
    private func startDictation() {
        task?.cancel()
        task = nil
        // Initializes the request variable
        request = SFSpeechAudioBufferRecognitionRequest()
        // Assigns the shared audio session instance to a constant
//        audioSession = AVAudioSession.sharedInstance()
        // Assigns the input node of the audio engine to a constant
        let inputNode = audioEngine.inputNode
         // If possible, the request variable is unwrapped and assigned to a local constant
        guard let request = request else { return }
        request.shouldReportPartialResults = true
        // Attempts to set various attributes and returns nil if fails
        try? audioSession!.setCategory(AVAudioSession.Category.record)
//        try? audioSession!.setCategory(AVAudioSession.Category.playAndRecord)
        try? audioSession!.setMode(AVAudioSession.Mode.measurement)
        try? audioSession!.setActive(true, options: .notifyOthersOnDeactivation)
        

        // Initializes the task with a recognition task
        task = speechRecognizer.recognitionTask(with: request, resultHandler: { (result, error) in
            guard let result = result else { return }
            self.textView!.text = result.bestTranscription.formattedString
            if error != nil || result.isFinal {
                self.audioEngine.stop()
                self.request = nil
                self.task = nil
                inputNode.removeTap(onBus: 0)
            }
        })
        let recordingFormat = inputNode.inputFormat(forBus: 0)
//        let recordingFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
 
}



extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
}
