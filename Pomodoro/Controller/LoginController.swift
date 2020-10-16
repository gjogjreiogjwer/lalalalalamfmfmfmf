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
    private let loginURL = "http://api.cervidae.com.au:8080/users/login"
    
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createIcon(textField: account, imageName: accountIcon)
        createIcon(textField: password, imageName: passwordIcon)
    }
    
    
    func createIcon(textField: UITextField, imageName: String){
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        textField.leftViewMode = .always
        if imageName == passwordIcon{
            textField.isSecureTextEntry = true
        }
        
        let icon = UIImageView(frame: CGRect(x: 11, y: 11, width: 20, height: 22))
        icon.image = UIImage(systemName: imageName)
        textField.leftView?.addSubview(icon)
    }
    
    
    
    
    @IBAction func login(_ sender: Any) {
        let paras = ["u": account.text!, "p": password.text!]
        AF.request(loginURL, method: .post, parameters: paras).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                print(message)
            }
        }
        performSegue(withIdentifier: "login", sender: nil)

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
