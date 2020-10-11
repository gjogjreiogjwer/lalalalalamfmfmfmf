//
//  MainMenuController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/10.
//

import UIKit

class MainMenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        jump(text: "List", offset: 200)
        jump(text: "Setting", offset: 80)
    }
    
    
    func jump(text:String, offset:Int){
        let subView = UIView()
        subView.contentMode = .scaleToFill
        subView.frame.size.width = 300
        subView.frame.size.height = 100
        subView.center.x = view.center.x - 30
        subView.center.y = view.center.y - CGFloat(offset)
        subView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        subView.layer.cornerRadius = 10.0

        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "mainbg")
        image.layer.cornerRadius = 10.0
        image.clipsToBounds = true
        image.frame.size.width = 300
        image.frame.size.height = 100
        image.center.x = subView.frame.width / 2
        image.center.y = subView.frame.height / 2
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth=true
        label.text = text
        label.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.frame.size.width = 100
        label.frame.size.height = 50
        label.center.x = subView.frame.width / 2 - 50
        label.center.y = subView.frame.height / 2

        subView.addSubview(image)
        subView.insertSubview(label, aboveSubview: image)
        view.addSubview(subView)
        
        subView.isUserInteractionEnabled = true

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
