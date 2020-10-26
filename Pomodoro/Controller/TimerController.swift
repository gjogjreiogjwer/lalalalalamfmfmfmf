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

/*
 Protocol for back transferring to TodosTableController
 */
protocol TimerDelegate {
    func didUpdateTime(time:Int)
}

/*
 Timer interface
 */
class TimerController: UIViewController {
    
    // Left time
    var time = 0.0
    
    // TimerDelegate delegate
    var delegate:TimerDelegate?
    
    // Array of themes
    private let themeArr = ["Spring", "Summer", "Autumn", "Winter"]
    
    // URL for getting quote
    private let quoteURL = "http://api.cervidae.com.au:8080/quotes"
    
    // URL for update user score
    private let updateURL = "http://api.cervidae.com.au:8080/users/"
    
    // Timer object
    private var timer = Timer()
    
    // Learning time
    private var learningTime = 0.0
    
    // Timer or not
    private var isCounting = false
    
    // Which theme
    private var i = 0
    
    // Music player object
    private var player: AVAudioPlayer?
    
    // Original button color
    private var originButtonColor: UIColor!
    
    // Unenabled button color
    private var unEnabledButtonColor: UIColor!
    
    // Timer progress object
    private var progress: KDCircularProgress!
    
    // Text view for showing quote
    private var textView: UITextView?
    
    // Music or not
    private var flag = false
    
    // Micro listen or not
    private var microOpen = false
    
    // Default quote
    private var quote = "Stop"
    
    // Micro relevant
    private var audioSession: AVAudioSession?
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    // Timer style
    static var timerStyle = 0
    
    // UI controls
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteBotton: UIBarButtonItem!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - System methods

    /*
     Init
     */
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
        else if TimerController.timerStyle == 1{
            startButton.isHidden = true
            pauseButton.isHidden = true
            
            // open distance sensor
            UIDevice.current.isProximityMonitoringEnabled = true
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
    
    
    /*
     Stop music when leaving
     @parameter animated: perform animation or not
     */
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
    
    
    // MARK: - Timer
    
    /*
     Update timer when counting
     */
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
    
    
    /*
     Start timer
     */
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
    
    
    /*
     Stop timer
     */
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
    
    
    // MARK: - UIButton action
    
    
    /*
     Execute when press "Start" button
     @parameter: sender: message when press button(empty in default)
     */
    @IBAction func startTimer(_ sender: Any) {
        start()
    }
    
    
    /*
     Execute when press "Pause" button
     @parameter: sender: message when press button(empty in default)
     */
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
    

    /*
     Execute when press "done" button
     @parameter: sender: message when press button(empty in default)
     */
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
    
    
    /*
     Execute when press "mute" button
     @parameter: sender: message when press button(empty in default)
     */
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
    
    
    /*
     Shake action to change themes
     */
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
    
    
    // MARK: - Distance sentor style
    
    /*
     Distance senter status change
     */
    @objc func statusChange(){
        if UIDevice.current.proximityState {
            start()
            print("close")
        }else{
            pause()
            print("far")
        }
    }
    
    
    // MARK: - Microphone style
    
    /*
     @parameter available: micro open or not
     */
    private func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            pauseButton.isEnabled = true
        } else {
            pauseButton.isEnabled = false
        }
    }
    
    
    /*
     microphone style
     */
    private func microphoneStyle(){
        if audioEngine.isRunning {
            microOpen = false
            request?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            
            //category: back to play music mode
            try? audioSession!.setCategory(AVAudioSession.Category.playback)
            
            //mode change from minimizition to speaker
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
    
    
    /*
     Start microphone
     */
    private func startDictation() {
        task?.cancel()
        task = nil
        
        // Initializes the request variable
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
         // If possible, the request variable is unwrapped and assigned to a local constant
        guard let request = request else { return }
        
        request.shouldReportPartialResults = true
        
        // Attempts to set various attributes and returns nil if fails
        try? audioSession!.setCategory(AVAudioSession.Category.record)
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
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request?.append(buffer)
        }
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    
    // MARK: - Helper
    
    /*
     Change theme
     */
    private func changeTheme(){
        let themeLabel = UILabel()
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
    
    
    /*
     Change music
     */
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
    
    
    /*
     Change background
     */
    private func changeBackground(){
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
    
    
    /*
     Request quote from server
     */
    private func getQuote(){
        AF.request(quoteURL, method: .get).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                let temp = message["payload", "quote"].stringValue
                print(temp)
                self.quote = temp
            }
        }
    }
    
    
    /*
     Timer progress init
     */
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
    
    
    /*
     Create quote text view
     */
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
}



