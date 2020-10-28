//
//  RankingController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit
import Alamofire
import SwiftyJSON

/*
 Ranking interface
 */
class RankingController: UIViewController {
    
    // Array of ranking
    var rankArr: [[String: String]] = []
    
    // URL for getting ranking
    private let rankingURL = "http://api.cervidae.com.au:8080/rankings?top=10&forced"
    
    // ranking number offset
    private let numOffset = -140
    
    // user name offset
    private let nameOffset = -10
    
    // score offset
    private let scoreOffset = 130
    
    // loading UILabel
    private var loadingLabel: UILabel!

    
    // MARK: - System methods

    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        MainCollectionController.setBackground(currentView: view)
        
        loading()
        getRankings()
        
    }
    
    
    // MARK: - Helper
    
    /*
     Regurest ranking from server
     */
    private func getRankings(){
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
                    }
                    print("get ranks success")
                    self.loadingLabel.removeFromSuperview()
                    self.showTitles(type: "No.", offset: self.numOffset)
                    self.showTitles(type: "name", offset: self.nameOffset)
                    self.showTitles(type: "score", offset: self.scoreOffset)
                    self.showRankings(type: "No.", offset: self.numOffset)
                    self.showRankings(type: "name", offset: self.nameOffset)
                    self.showRankings(type: "score", offset: self.scoreOffset)
                }
                else{
                    print("get ranks error")
                }
            }
        }
    }
    
    
    /*
     Before getting ranking
     */
    private func loading(){
        loadingLabel = UILabel()
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 50)
        if traitCollection.userInterfaceStyle == .dark{
            loadingLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else{
            loadingLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        loadingLabel.textAlignment = .center
        loadingLabel.frame.size.width = 400
        loadingLabel.frame.size.height = 400
        loadingLabel.center.x = view.center.x
        loadingLabel.center.y = view.center.y
        loadingLabel.text = "Loading..."
        view.addSubview(loadingLabel)
    }
    
    
    /*
     Show header
     @parameter type: header name
     @parameter offset: UILabel offset
     */
    private func showTitles(type: String, offset: Int){
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        if traitCollection.userInterfaceStyle == .dark{
            titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else{
            titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        titleLabel.textAlignment = .center
        titleLabel.frame.size.width = 100
        titleLabel.frame.size.height = 100
        titleLabel.center.x = view.center.x + CGFloat(offset)
        titleLabel.center.y = view.center.y - 180
        titleLabel.text = type
        view.addSubview(titleLabel)
    }
    
    
    /*
     Show ranking
     @parameter type: header name
     @parameter offset: UILabel offset

     */
    private func showRankings(type: String, offset: Int){
        let rankLabel = UILabel()
        rankLabel.font = UIFont.systemFont(ofSize: 30)
        if traitCollection.userInterfaceStyle == .dark{
            rankLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else{
            rankLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        rankLabel.textAlignment = .center
        rankLabel.numberOfLines = 0
        rankLabel.frame.size.width = 300
        rankLabel.frame.size.height = 600
        rankLabel.center.x = view.center.x + CGFloat(offset)
        rankLabel.center.y = view.center.y + 50
        
        var text = ""
        for i in 0...rankArr.count-1{
            if type == "No."{
                text += "\(i+1)\n"
            }
            else{
                text += "\(String(rankArr[i][type]!))\n"
            }
        }
        rankLabel.text = text
        view.addSubview(rankLabel)
    }
}
