//
//  LoginController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit
import Alamofire
import SwiftyJSON

/*
 Login Interface
 */
class LoginController: UIViewController {

    // Icon account system name
    private let accountIcon = "person"
    
    // Icon passward system name
    private let passwordIcon = "key"
    
    // URL for login
    private let loginURL = "http://api.cervidae.com.au:8080/users/login"
    
    // URL for register
    private let registerURL = "http://api.cervidae.com.au:8080/users/register"
    
    // Unique userName for local store
    private var uniqueUserName = "null"
    
    // Has account or not
    private var hasAccount = true
    
    // textfield of account and password is null or not
    private var accountNull = false
    
    // Score of the user
    static var currentScore = 0.0
    
    // Current user name
    static var userName = ""
    
    // UI controls
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    // MARK: - System methods

    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createIconImage()
        
        account.text = LoginController.userName
        account.becomeFirstResponder()
        
        createSubicon(textField: account, imageName: accountIcon)
        createSubicon(textField: password, imageName: passwordIcon)
    }
    
    
    /*
     Hide navigation bar
     @parameter animated: perform animation or not
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    /*
     Show navigation bar in next page
     @parameter animated: perform animation or not
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    // MARK: - UIButton action
    
    /*
     Execute when press "login" button
     @parameter: sender: message when press button(empty in default)
     */
    @IBAction func login(_ sender: Any) {
        let paras = ["u": account.text!, "p": password.text!]
        beforeLogin(paras: paras)
        
        if hasAccount{
            doingLogin(paras: paras)
        }
        else{
            doingRegister(paras: paras)
        }
    }
    
    
    /*
     Execute when press "No Account?" or "Return login" button
     @parameter: sender: message when press button(empty in default)
     */
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
    
    
    // MARK: - Create UI
    
    /*
     Create icon
     */
    private func createIconImage(){
        let image = UIImageView()
        image.frame.size.width = 80
        image.frame.size.height = 80
        image.center.x = view.center.x
        image.center.y = view.center.y - 300
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "icon")
        view.addSubview(image)
    }

    
    /*
     Create subIcon
     */
    private func createSubicon(textField: UITextField, imageName: String){
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
    
    
    /*
     Show notice when specific action happens
     @parameter text: notice message
     */
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
        info.center.y = -200
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        info.center.y += 350
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       options: .curveEaseIn) {
            info.center.y -= 350
        } completion: { _ in
            info.removeFromSuperview()
        }
    }
    
    
    // MARK: - Helper
    
    /*
     Determine if the login preconditions are met
     @parameter paras: dictionary of username and passward
     */
    private func beforeLogin(paras: [String:String]){
        if paras["u"] == ""{
            notice(text: "Need Account!")
            accountNull = true
            return
        }
        if paras["p"] == ""{
            notice(text: "Need password!")
            accountNull = true
            return
        }
        if paras["u"] == "null"{
            accountNull = false
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    
    /*
     Request message from server when login
     @parameter paras: dictionary of username and passward
     */
    private func doingLogin(paras: [String:String]){
        AF.request(loginURL, method: .post, parameters: paras).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                if message["success"] == 1{
                    LoginController.currentScore = message["payload", "score"].doubleValue
                    LoginController.userName = message["payload", "username"].stringValue
                    print(message)
                    self.accountNull = false
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                else{
                    if !self.accountNull{
                        self.notice(text: "Wrong password!")
                    }
                    print("login error")
                }
            }
        }
        
    }
    
    
    /*
     Request message from server when register
     @parameter paras: dictionary of username and passward
     */
    private func doingRegister(paras: [String:String]){
        UserDefaults.standard.set(paras["u"], forKey: "unique")
        AF.request(registerURL, method: .post, parameters: paras).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                if message["success"] == 1{
                    LoginController.currentScore = 0
                    LoginController.userName = message["payload", "username"].stringValue
                    self.accountNull = false
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                else{
                    print("register error")
                }
            }
        }
    }
    
}
