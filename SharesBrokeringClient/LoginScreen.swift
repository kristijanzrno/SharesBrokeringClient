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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
 
    
    func loginHandler(xml: XMLIndexer?){
        if(WSClient().processLogin(xml: xml)){
            print("Successfully logged in...")
        }else{
            print("Could not log in...")
        }
      
   }
    
    @IBAction func login(_ sender: Any) {
        WSClient().login(authUsername: usernameTF.text ?? "", authPassword: passwordTF.text ?? "", handler: loginHandler)
    }
    

    
}
