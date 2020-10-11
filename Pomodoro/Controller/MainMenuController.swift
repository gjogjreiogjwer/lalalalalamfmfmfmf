//
//  MainMenuController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/10.
//

import UIKit

class MainMenuController: UIViewController {
    
    let dict:[String:String] = ["List": "Each task can be added, deleted, edited, and queried. Moreover, each task takes different time to complete.", "Setting": "Timing mode selection and account management."]

    override func viewDidLoad() {
        super.viewDidLoad()

        jump(text: "List", offset: 200)
        jump(text: "Setting", offset: 0)
    }
    
    
    func jump(text:String, offset:Int){
        let subView = UIView()
        subView.contentMode = .scaleToFill
        subView.frame.size.width = 380
        subView.frame.size.height = 180
        subView.center.x = view.center.x
        subView.center.y = view.center.y - CGFloat(offset)
//        subView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        subView.layer.cornerRadius = 20.0
        subView.isUserInteractionEnabled = true
        
        let background = UIImageView()
        background.contentMode = .scaleToFill
        background.image = UIImage(named: "purple")
        background.layer.cornerRadius = 20.0
        background.clipsToBounds = true
        background.frame.size.width = subView.frame.width
        background.frame.size.height = subView.frame.height
        background.center.x = subView.frame.width / 2
        background.center.y = subView.frame.height / 2
        
        background.layer.masksToBounds = false
        background.layer.shadowOpacity = 0.6
        background.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        background.layer.shadowOffset = CGSize(width: 10, height: 10)
        background.layer.shadowRadius = 3
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 40)
        title.adjustsFontSizeToFitWidth=true
        title.text = text
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.frame.size.width = 100
        title.frame.size.height = 50
        title.center.x = subView.frame.width / 2 - 100
        title.center.y = subView.frame.height / 2 - 50
        
        let describe = UILabel()
        describe.font = UIFont.systemFont(ofSize: 20)
//        describe.adjustsFontSizeToFitWidth=true
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
                
//        describe.frame.origin.x = 50
//        describe.frame.origin.y = 45
//        print(describe.frame)
//        print("xxx   \(title.frame)")
        
        subView.addSubview(background)
        subView.insertSubview(title, aboveSubview: background)
        subView.insertSubview(describe, aboveSubview: background)
        view.addSubview(subView)

        if text == "List"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainMenuController.handleTapToList(sender:)))
            subView.addGestureRecognizer(tap)
        }
        else if text == "Setting"{
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainMenuController.handleTapToSetting(sender:)))
            subView.addGestureRecognizer(tap)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
