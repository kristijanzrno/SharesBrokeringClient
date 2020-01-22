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
    
    // Handling the response of the "account block" request to the WS
    func blockHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:changeAccountAccessResponse")){
            self.presentingViewController!.view.makeToast("Successfully changed account access mode!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not change account access mode...")
        }
    }
    
    // Processing the account deletion response
    func deleteAccountHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:deleteAccountResponse")){
            self.presentingViewController!.view.makeToast("Successfully deleted account!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not delete account...")
        }
    }
    
    // Sending the block request to the server
    @IBAction func toggleBlock(_ sender: Any) {
        let blocked:Bool? = !(account!.accountBlocked)
        WSClient().changeAccountAccess(authUsername: authUsername!, authPassword: authPassword!, accountName: account!.accountName, blocked: blocked!.description, handler: blockHandler)
    }
    
    // Sending the delete account request to the server
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            WSClient().deleteAccount(authUsername: self.authUsername!, authPassword: self.authPassword!, accountName: self.account!.accountName, handler: self.deleteAccountHandler)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
