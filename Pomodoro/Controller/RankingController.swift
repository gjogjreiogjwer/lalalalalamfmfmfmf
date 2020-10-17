//
//  RankingController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit

class RankingController: UIViewController {
    
    private var rankLabel: UILabel!
    var rankArr: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        MainMenuController.setBackground(currentView: view)
        showRankings()
//        print(rankArr)
    }
    
  
    
    
    private func showRankings(){
        rankLabel = UILabel()
        rankLabel.font = UIFont.systemFont(ofSize: 30)
        rankLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rankLabel.textAlignment = .center
        rankLabel.numberOfLines = 0
        rankLabel.frame.size.width = 300
        rankLabel.frame.size.height = 600
        rankLabel.center.x = view.center.x
        rankLabel.center.y = view.center.y
        
        var text = ""
        for i in 0...9{
            text += "\(String(rankArr[i]["name"]!)), \(String(rankArr[i]["score"]!))\n"
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
