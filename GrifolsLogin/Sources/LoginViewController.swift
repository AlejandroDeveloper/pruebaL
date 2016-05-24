//
//  LoginViewController.swift
//  GrifolsLogin
//
//  Created by Alejandro Palomo Rodriguez on 24/5/16.
//
//

import UIKit

protocol LoginProtocol {
    func getCredentials(user:String,Password:String)
}

@IBDesignable class LoginViewController: UIViewController {

    @IBOutlet weak private var txtUser: UITextField!
    @IBOutlet weak private var txtPassword: UITextField!
    @IBOutlet weak private var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(animated: Bool) {
         configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureView() {
        let borderUser = CALayer()
        let borderPass = CALayer()
        let width = CGFloat(1.0)
        
        borderUser.borderColor = UIColor.whiteColor().CGColor
        borderPass.borderColor = UIColor.whiteColor().CGColor
        
        //User
        borderUser.frame = CGRect(x: 0, y: txtUser.frame.size.height - width, width:  txtUser.frame.size.width, height: txtUser.frame.size.height)
        
        borderUser.borderWidth = width
        txtUser.layer.addSublayer(borderUser)
        txtUser.layer.masksToBounds = true
        
        txtUser.attributedPlaceholder = NSAttributedString(string:"User",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //Password
        borderPass.frame = CGRect(x: 0, y: txtPassword.frame.size.height - width, width:  txtPassword.frame.size.width, height: txtPassword.frame.size.height)
        borderPass.borderWidth = width
        txtPassword.layer.addSublayer(borderPass)
        txtPassword.layer.masksToBounds = true
        
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        btnLogin.layer.cornerRadius = 8.0
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.borderColor = UIColor.whiteColor().CGColor
        btnLogin.layer.borderWidth = 2
        
        
    }
    
    //MARK:-Send Login
    
    @IBAction func sendLogin(sender: UIButton) {
        LoginService.sharedInstance.signInWithUser(txtUser.text!, password: txtPassword.text!)
    }

}
