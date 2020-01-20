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
    }
    
 
    
    func accountHandler(xml: XMLIndexer?){
        let accounts:[Account]? = WSClient().processAccounts(xml: xml)
    }
    
    func loginHandler(xml: XMLIndexer?){
        if(WSClient().processLogin(xml: xml)){
            //go to the next screen
            statusTV.text = ""
        }else{
            print("Could not log in...")
            statusTV.text = "Could not log in..."
        }
      
   }
    
    @IBAction func login(_ sender: Any) {
        WSClient().login(authUsername: usernameTF.text ?? "", authPassword: passwordTF.text ?? "", handler: loginHandler)
    }
    

    
}
