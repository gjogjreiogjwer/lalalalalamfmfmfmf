//
//  RankingController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit

class RankingController: UIViewController {
    
    var rankArr: [[String: String]] = []
    private let numOffset = -140
    private let nameOffset = -10
    private let scoreOffset = 130

    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .light
        MainCollectionController.setBackground(currentView: view)
      
        
        showRankings(type: "No.", offset: numOffset)
        showRankings(type: "name", offset: nameOffset)
        showRankings(type: "score", offset: scoreOffset)
        showTitles(type: "No.", offset: numOffset)
        showTitles(type: "name", offset: nameOffset)
        showTitles(type: "score", offset: scoreOffset)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//        navigationController?.navigationBar.alpha = 0
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
  
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
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
