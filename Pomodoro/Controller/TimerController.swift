//
//  TimerController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/7.
//

import UIKit

protocol TimerDelegate {
    func didUpdateTime(time:Int)
}


class TimerController: UIViewController {
    
    var time = 0.0
    var timer = Timer()
    var isPlaying = false
    var delegate:TimerDelegate?
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @objc func UpdateTimer() {
        time = time - 0.1
        timeLabel.text = String(format: "%.1f", time)
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if(isPlaying) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
            
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimerController.UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
            
        timer.invalidate()
        isPlaying = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = String(time)
        pauseButton.isEnabled = false

    }
    
    @IBAction func done(_ sender: Any) {
        delegate?.didUpdateTime(time: Int(time))
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
