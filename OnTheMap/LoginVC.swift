//
//  LoginVC.swift
//  OnTheMap
//
//  Created by A Abdullah on 7/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {
    
    @IBOutlet weak var email : CustomTextField!
    @IBOutlet weak var password : CustomTextField!
    @IBOutlet weak var logoTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var logoWidthAnchor: NSLayoutConstraint!
    
    static var share = LoginVC()
    
    static var userInformation : UserAccountAndSessionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        settingUpKeyboardNotifications()
    }
    
    func setupUIElements() {
        password.textField.isSecureTextEntry = true
        email.textField.setupPlaceholder(text: "Email")
        password.textField.setupPlaceholder(text: "Password")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
        // login action
    
    @IBAction func loginAction(_ sender : UIButton) {
        
        // textfields validation
        guard let email = email.textField.text, email.isEmpty == false, let password = password.textField.text, password.isEmpty == false else {
            Alert.BasicAlert(vc: self, message: "Please fill all fields")
            return
        }
        
        ActivityIndicator.startActivity(view: self.view)
        
        API.share.userAuth(email: email, password: password, completion: {userInfo,error in
            // show error message if an error occured
            if  error != nil {
                Alert.BasicAlert(vc: self, message: "can't connect to server")
                return
            }
            
            if userInfo?.account.registered != nil {
                
                LoginVC.userInformation = UserAccountAndSessionData.init(account: UserAccountData.init(registered: userInfo?.account.registered, key: userInfo?.account.key), session: UserSessionData.init(id: userInfo?.session.id, expiration: userInfo?.session.expiration))
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToTabbar", sender: nil)
                    ActivityIndicator.stopActivity()
                }
            } else {
                DispatchQueue.main.async {
                    ActivityIndicator.stopActivity()
                }
                Alert.BasicAlert(vc: self, message: "email or password not correct")
            }
            
        })
    }
    
    // open signUp link in safari browser in order to signUp
     @IBAction func singup(_ sender: Any) {
     let url = URL(string: "https://auth.udacity.com/sign-up")
         guard let newUrl = url else {return}
         let svc = SFSafariViewController(url: newUrl)
         present(svc, animated: true, completion: nil)
     }

}


// Keyboard section
extension LoginVC {
    
    func settingUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.logoTopAnchor.constant = 10
        self.logoWidthAnchor.constant = 75
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    self.logoTopAnchor.constant = 50
    self.logoWidthAnchor.constant = 130
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
