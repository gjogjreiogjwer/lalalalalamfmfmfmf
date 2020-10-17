//
//  MainMenuController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainMenuController: UIViewController {
    
    private let dict:[String:String] = [
        "List": "Each task can be added, deleted, edited, and queried. Moreover, each task takes different time to complete.",
        "Setting": "Timing mode selection and account management.",
        "Ranking": "Ranking of scores."]
    private var shadowView:UIView!
    private var subView:UIView!
    private var background:UIImageView!
    private var subViewTitle:UILabel!
    private var describe:UILabel!
    private let rankingURL = "http://api.cervidae.com.au:8080/rankings?top=10&forced"
//    private var rankings: JSON?
    private var rankArr: [[String: String]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        TimerController.timerStyle = UserDefaults.standard.integer(forKey: "style")
        
        jump(text: "List", offset: 200)
        jump(text: "Ranking", offset: 0)
        jump(text: "Setting", offset: -200)
        
        getRankings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    class func setBackground(currentView: UIView){
        let background = UIImageView(frame: currentView.frame)
        background.contentMode = .scaleAspectFill
        background.image = UIImage(named: "Yeta")
        background.alpha = 0.3
        currentView.addSubview(background)
    }
    
    private func createShadowView(offset:Int){
        shadowView = UIView()
        shadowView.frame.size.width = 380
        shadowView.frame.size.height = 180
        shadowView.center.x = view.center.x
        shadowView.center.y = view.center.y - CGFloat(offset)
        shadowView.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 5.0
        shadowView.clipsToBounds = false
    }
    
    
    private func createSubView(){
        subView = UIView()
        subView.contentMode = .scaleToFill
        subView.frame.size.width = shadowView.frame.width
        subView.frame.size.height = shadowView.frame.height
        subView.center.x = shadowView.frame.width / 2
        subView.center.y = shadowView.frame.height / 2
        subView.layer.cornerRadius = 20.0
        subView.isUserInteractionEnabled = true
    }
    
    
    private func createBackground(){
        background = UIImageView()
        background.contentMode = .scaleToFill
        background.image = UIImage(named: "Pinky")
        background.layer.cornerRadius = 20.0
        background.frame.size.width = subView.frame.width
        background.frame.size.height = subView.frame.height
        background.center.x = subView.frame.width / 2
        background.center.y = subView.frame.height / 2
        background.layer.masksToBounds = true
    }
    
    
    private func createTitleLabel(text:String){
        subViewTitle = UILabel()
        subViewTitle.font = UIFont.boldSystemFont(ofSize: 40)
        subViewTitle.adjustsFontSizeToFitWidth=true
        subViewTitle.text = text
        subViewTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subViewTitle.frame.size.width = 100
        subViewTitle.frame.size.height = 50
        subViewTitle.center.x = subView.frame.width / 2 - 100
        subViewTitle.center.y = subView.frame.height / 2 - 50
    }
    
    
    private func createDescribeLabel(text:String){
        describe = UILabel()
        describe.font = UIFont.systemFont(ofSize: 20)
        describe.numberOfLines = 0
        describe.text = dict[text]
        describe.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        describe.frame.size.width = 300
        describe.frame.size.height = 150
        describe.center.x = subView.frame.width / 2
        if text == "List"{
            describe.center.y = subView.frame.height / 2 + 20
        }
        else if text == "Setting"{
            describe.center.y = subView.frame.height / 2
        }
    }
    
    
    private func jump(text:String, offset:Int){
        createShadowView(offset: offset)
        createSubView()
        createBackground()
        createTitleLabel(text: text)
        createDescribeLabel(text: text)
        
        subView.addSubview(background)
        subView.insertSubview(subViewTitle, aboveSubview: background)
        subView.insertSubview(describe, aboveSubview: background)
        shadowView.addSubview(subView)
        view.addSubview(shadowView)

        if text == "List"{
//            print(shadowView.frame)
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainMenuController.handleTapToList(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Setting"{
//            print(shadowView.frame)
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainMenuController.handleTapToSetting(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Ranking"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainMenuController.handleTapToRanking(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
    }
    
    
    @objc func handleTapToList(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "List", sender: nil)
        }
    }
    
    
    @objc func handleTapToSetting(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "Setting", sender: nil)
        }
    }
    
    @objc func handleTapToRanking(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "Ranking", sender: nil)
        }
    }
    
    
    func getRankings(){
        AF.request(rankingURL, method: .get).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                if message["success"] == 1{
                    for i in 1...10{
                        let tempName = message["payload", "rankMap", String(i), "username"].stringValue
                        let tempScore = message["payload", "rankMap", String(i), "score"].stringValue
                        self.rankArr.append(["name": tempName, "score": tempScore])
                    }
                    
                    print("get ranks success")
                }
                else{
                    print("get ranks error")
                }
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Ranking"{
            let vc = segue.destination as! RankingController
//            vc.rankings? = rankings!
            vc.rankArr = rankArr
        }
    }
    

}
