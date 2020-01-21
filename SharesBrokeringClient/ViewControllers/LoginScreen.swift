//
//  LoginScreen.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 19/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import AlamofireSoap
import SWXMLHash

class LoginScreen: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var statusTV: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(UserDefaults.standard.bool(forKey: "loggedIn")){
            WSClient().login(authUsername: UserDefaults.standard.string(forKey: "username") ?? "", authPassword: UserDefaults.standard.string(forKey: "password") ?? "", handler: loginHandler)
        }
    }
    
    
    
    func loginHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:loginResponse")){
            //go to the next screen
            statusTV.text = ""
            UserDefaults.standard.set(true, forKey: "loggedIn")
            if let tabViewController = storyboard?.instantiateViewController(identifier: "tabbedVC") as? TabbedViewController {
                tabViewController.modalPresentationStyle = .fullScreen
                passwordTF.text = ""
                self.present(tabViewController, animated: true, completion: nil)
            }
            
        }else{
            statusTV.text = "Could not log in..."
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        UserDefaults.standard.set(usernameTF.text ?? "", forKey: "username")
        UserDefaults.standard.set(passwordTF.text ?? "", forKey: "password")
        WSClient().login(authUsername: usernameTF.text ?? "", authPassword: passwordTF.text ?? "", handler: loginHandler)
    }
    
    
    
}
