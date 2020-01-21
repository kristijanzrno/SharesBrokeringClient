//
//  EditAccountPopup.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 21/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift

class EditAccountPopup: UIViewController{
    
    @IBOutlet weak var usernameTV: UILabel!
    @IBOutlet weak var accountLevelTV: UILabel!
    @IBOutlet weak var blockedTV: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    var presenter:AdminAccountsScreen? = nil
    
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    
    var account:Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        usernameTV.text = "Username: " + account!.accountName
        accountLevelTV.text = "Account Level: " + String(format:"%i", account!.accountLevel)
        blockedTV.text = "Blocked: " + (account?.accountBlocked.description)!
        
        if(account!.accountBlocked){
            blockButton.titleLabel?.text = "Unblock"
        }
    }
    
    func blockHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:changeAccountAccessResponse")){
            self.presentingViewController!.view.makeToast("Successfully changed account access mode!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not change account access mode...")
        }
    }
    
    func deleteAccountHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:deleteAccountResponse")){
            self.presentingViewController!.view.makeToast("Successfully deleted account!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not delete account...")
        }
    }
    
    @IBAction func toggleBlock(_ sender: Any) {
        let blocked:Bool? = !(account!.accountBlocked)
        WSClient().changeAccountAccess(authUsername: authUsername!, authPassword: authPassword!, accountName: account!.accountName, blocked: blocked!.description, handler: blockHandler)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        WSClient().deleteAccount(authUsername: authUsername!, authPassword: authPassword!, accountName: account!.accountName, handler: deleteAccountHandler)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
