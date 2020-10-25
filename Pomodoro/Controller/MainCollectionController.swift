//
//  MainCollectionController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "cell"

class MainCollectionController: UICollectionViewController {
    
    private var cardViewArr: [UIView] = []
    private let styles = ["Normal", "Flip", "Microphone"]
    private let dict:[String:String] = [
        "List": "Each task can be added, deleted, edited, and queried. Moreover, each task takes different time to complete.",
        "Setting": "Account message.",
        "Ranking": "Ranking of scores.",
        "Style": "Current style: "]
//    private var shadowView:UIView!
//    private var subView:UIView!
//    private var background:UIImageView!
//    private var subViewTitle:UILabel!
//    private var describe:UILabel!
    private var styleDescribe: UILabel!
    private let rankingURL = "http://api.cervidae.com.au:8080/rankings?top=10&forced"
    private var rankArr: [[String: String]] = []
    private var cardFrame: CGRect!
    private let cellsNum = 4
    

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        TimerController.timerStyle = UserDefaults.standard.integer(forKey: "style")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRankings()
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Ranking"{
            let vc = segue.destination as! RankingController
//            vc.rankings? = rankings!
            vc.rankArr = rankArr
//            vc.modalPresentationStyle = .fullScreen
        }
        else if segue.identifier == "Style"{
            let vc = segue.destination as! StyleTableController
            vc.describe = styleDescribe
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellsNum
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionCell

        cardFrame = cell.cardView.frame

        if indexPath.row == 0{
            jump(text: "List")
        }
        else if indexPath.row == 1{
            jump(text: "Ranking")
        }
        else if indexPath.row == 2{
            jump(text: "Style")
        }
        else if indexPath.row == 3{
            jump(text: "Setting")
        }
        
        cell.cardView.addSubview(cardViewArr[indexPath.row])
//        cell.cardView.backgroundColor = .red
//        print(cell.cardView.frame)
     
        return cell
    }
    
    
    private func jump(text:String){
        let shadowView = createShadowView()
        let subView = createSubView(shadowView: shadowView)
        let background = createBackground(subView: subView)
        let subViewTitle = createTitleLabel(text: text, subView: subView)
        let describe = createDescribeLabel(text: text, subView: subView)
        
        subView.addSubview(background)
        subView.insertSubview(subViewTitle, aboveSubview: background)
        subView.insertSubview(describe, aboveSubview: background)
        shadowView.addSubview(subView)
        cardViewArr.append(shadowView)
                
        if text == "List"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainCollectionController.handleTapToList(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Setting"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainCollectionController.handleTapToSetting(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Ranking"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainCollectionController.handleTapToRanking(sender:)))
            shadowView.addGestureRecognizer(tap)
        }
        else if text == "Style"{
            let tap = UITapGestureRecognizer(target: self, action: #selector(MainCollectionController.handleTapToStyle(sender:)))
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
    
    
    @objc func handleTapToStyle(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "Style", sender: nil)
        }
    }
    
    
    func getRankings(){
        AF.request(rankingURL, method: .get).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                if message["success"] == 1{
                    self.rankArr = []
                    for i in 1...10{
                        let tempName = message["payload", "rankMap", String(i), "username"].stringValue
                        let tempScore = message["payload", "rankMap", String(i), "score"].stringValue
                        self.rankArr.append(["name": tempName, "score": tempScore])
//                        print(message["payload", "rankMap", "2"])
//                        print(self.rankArr)
                    }
                    
                    print("get ranks success")
                }
                else{
                    print("get ranks error")
                }
            }
        }
    }
    
    private func createShadowView() -> UIView{
        let shadowView = UIView(frame: cardFrame)

        shadowView.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 5.0
        shadowView.clipsToBounds = false
        return shadowView
    }
    
    
    private func createSubView(shadowView: UIView) -> UIView{
        let subView = UIView()
        subView.contentMode = .scaleToFill
        subView.frame.size.width = shadowView.frame.width
        subView.frame.size.height = shadowView.frame.height
        subView.center.x = shadowView.frame.width / 2
        subView.center.y = shadowView.frame.height / 2
        subView.layer.cornerRadius = 20.0
        subView.isUserInteractionEnabled = true
        return subView
    }
    
    
    private func createBackground(subView: UIView) -> UIImageView{
        let background = UIImageView()
        background.contentMode = .scaleToFill
        background.image = UIImage(named: "Pinky")
        background.layer.cornerRadius = 20.0
        background.frame.size.width = subView.frame.width
        background.frame.size.height = subView.frame.height
        background.center.x = subView.frame.width / 2
        background.center.y = subView.frame.height / 2
        background.layer.masksToBounds = true
        return background
    }
    
    
    private func createTitleLabel(text:String, subView: UIView) -> UILabel{
        let subViewTitle = UILabel()
        subViewTitle.font = UIFont.boldSystemFont(ofSize: 40)
//        subViewTitle.adjustsFontSizeToFitWidth=true
        subViewTitle.text = text
        subViewTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subViewTitle.frame.size.width = 200
        subViewTitle.frame.size.height = 50
        subViewTitle.center.x = subView.frame.width / 2 - 60
        subViewTitle.center.y = subView.frame.height / 2 - 50
        return subViewTitle
    }
    
    
    func createDescribeLabel(text:String, subView: UIView) -> UILabel{
        let describe = UILabel()
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
        else if text == "Style"{
            describe.text! += "\(styles[TimerController.timerStyle])"
            styleDescribe = describe
            
        }
        return describe
    }

 

}

extension MainCollectionController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 380, height: 180)
    }
}

//extension MainCollectionController: StyleDelegate{
//    func updateDescribe(style: Int){
//        styleDescribe.text = "Current style: \(styles[style])"
//        styleDescribe.text = "xxx"
//    }
//}
