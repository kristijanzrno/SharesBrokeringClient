//
//  ChangePassword.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift

class ChangePasswordPopup: UIViewController{
    
    @IBOutlet weak var currentPasswordTV: UITextField!
    @IBOutlet weak var newPasswordTV: UITextField!
    
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
  
    override func viewDidLoad() {
             super.viewDidLoad()
    }
    
    func changePasswordHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:changeAccountPasswordResponse")){
            UserDefaults.standard.set(newPasswordTV.text, forKey: "password")
            self.presentingViewController!.view.makeToast("Successfully changed password!")
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not change password...")
        }
    }
    @IBAction func changePassword(_ sender: Any) {
        WSClient().changeAccountPassword(authUsername: authUsername!, authPassword: currentPasswordTV.text!, newPassword: newPasswordTV.text!, handler: changePasswordHandler)
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
