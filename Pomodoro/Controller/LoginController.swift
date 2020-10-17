//
//  LoginController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginController: UIViewController {

    private let accountIcon = "person"
    private let passwordIcon = "key"
    private var hasAccount = true
    private let loginURL = "http://api.cervidae.com.au:8080/users/login"
    private let registerURL = "http://api.cervidae.com.au:8080/users/register"
    var currentAccount = ""
    
    static var currentScore = 0.0
    static var userName = "null"
    
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
        let image = UIImageView()
        image.frame.size.width = 80
        image.frame.size.height = 80
        image.center.x = view.center.x
        image.center.y = view.center.y - 250
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "icon")
        view.addSubview(image)
        
        account.text = currentAccount
        account.becomeFirstResponder()
        
        createIcon(textField: account, imageName: accountIcon)
        createIcon(textField: password, imageName: passwordIcon)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    
    
    func createIcon(textField: UITextField, imageName: String){
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        textField.leftViewMode = .always
        if imageName == passwordIcon{
            textField.isSecureTextEntry = true
        }
        
        let icon = UIImageView(frame: CGRect(x: 11, y: 11, width: 23, height: 22))
        icon.image = UIImage(systemName: imageName)
        textField.leftView?.addSubview(icon)
    }
    
    
    
    
    @IBAction func login(_ sender: Any) {
        let paras = ["u": account.text!, "p": password.text!]
        if paras["u"] == ""{
            notice(text: "Need Account!")
            return
        }
        if paras["p"] == ""{
            notice(text: "Need password!")
            return 
        }
        
        if hasAccount{
            AF.request(loginURL, method: .post, parameters: paras).responseJSON{
                response in
                if let json = response.value{
                    let message = JSON(json)
                    if message["success"] == 1{
                        LoginController.currentScore = message["payload", "score"].doubleValue
                        LoginController.userName = message["payload", "username"].stringValue
                        print(message)
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                    else{
                        print("login error")
                    }
                }
            }
        }
        else{
            AF.request(registerURL, method: .post, parameters: paras).responseJSON{
                response in
                if let json = response.value{
                    let message = JSON(json)
                    if message["success"] == 1{
                        LoginController.currentScore = 0
                        LoginController.userName = message["payload", "username"].stringValue
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                    else{
                        print("register error")
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func register(_ sender: Any) {
        if hasAccount{
            hasAccount = !hasAccount
            loginButton.setTitle("Register", for: .normal)
            registerButton.setTitle("Return login", for: .normal)
        }
        else{
            hasAccount = !hasAccount
            loginButton.setTitle("Login", for: .normal)
            registerButton.setTitle("No account?", for: .normal)
        }
        
    }
    
    
    private func notice(text: String){
        let info = UILabel()
        info.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        info.alpha = 0.5
        info.layer.cornerRadius = 5.0
        info.font = UIFont.systemFont(ofSize: 23)
        info.numberOfLines = 0
        info.text = text
            
        info.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        info.textAlignment = .center
        view.addSubview(info)
        
        info.frame.size.width = 200
        info.frame.size.height = 100
        info.center.x = view.center.x
        info.center.y = view.frame.height + 200
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        info.center.y -= 350
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       options: .curveEaseIn) {
            info.center.y += 350
        } completion: { _ in
            info.removeFromSuperview()
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
