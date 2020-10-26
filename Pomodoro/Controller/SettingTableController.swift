//
//  SettingController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/10.
//

import UIKit

/*
 Setting interface
 */
class SettingTableController: UITableViewController {
    
    // About us infomation
    private let aboutUsInfo = """
                    Group-W01/16-4
                    
                    Yicheng Jin
                    ChongZheng Zhao
                    Yuyang Wang
                    Runfeng Du
                    Tao Ge
                    Shuai Mou
                    """

    // UI contorl for about us cell
    @IBOutlet weak var aboutUsCell: UITableViewCell!
    
    
    // MARK: - System methods

    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        print(aboutUsCell.frame.height)
        MainCollectionController.setBackground(currentView: view)
        let tap = UITapGestureRecognizer(target: self, action:#selector(SettingTableController.handleTapToAboutUs(sender:)))
        aboutUsCell.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Helper
    
    /*
     Tap gesture when press "About us" cell
     */
    @objc func handleTapToAboutUs(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            showUs()
        }
    }
    
    
    /*
     Create UILabel to show about us information
     */
    private func showUs(){
        let info = UILabel()
        info.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        info.alpha = 0.5
        info.layer.cornerRadius = 5.0
        info.font = UIFont.systemFont(ofSize: 23)
        info.numberOfLines = 0
        info.text = aboutUsInfo
        info.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        info.textAlignment = .center
        tableView.addSubview(info)
        
        info.frame.size.width = 280
        info.frame.size.height = 250
        info.center.x = tableView.center.x
        info.center.y = tableView.frame.height + 200
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        info.center.y -= 450
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       options: .curveEaseIn) {
            info.center.y += 450
        } completion: { _ in
            info.removeFromSuperview()
        }
    }

}
