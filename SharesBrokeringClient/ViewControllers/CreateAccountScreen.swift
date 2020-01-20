//
//  CreateAccountScreen.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash

class CreateAccountScreen:UIViewController{
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var statusTV: UILabel!
    
    override func viewDidLoad() {
         super.viewDidLoad()
     }
     
    func createAccountHandler(xml: XMLIndexer?){
         if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:createAccountResponse")){
             //go to the next screen
             statusTV.text = ""
            self.dismiss(animated: true, completion: nil)
         }else{
             statusTV.text = "Could not create account, please try again..."
         }
       
    }
    @IBAction func createAccount(_ sender: Any) {
          WSClient().createAccount(accountUsername: usernameTF.text ?? "", accountPassword: passwordTF.text ?? "", handler: createAccountHandler)
    }
    
}
