//
//  AdminAccountsScreen.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 21/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift

class AdminAccountsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var accounts:[Account] = []
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    // Fetching the data each time the view re-appears
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    // Processing the fetched data
    func fetchAccountsHandler(xml:XMLIndexer?){
        let accList = WSClient().processAccounts(xml: xml)
        if(accList != nil){
            accounts.removeAll()
            accounts.append(contentsOf: accList!)
            self.tableView.reloadData()
        }
    }
    // Sending the getAccounts() request
    func fetchData(){
        WSClient().getAccounts(authUsername: authUsername!, authPassword: authPassword!, handler: fetchAccountsHandler)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating the custom account cell and populating it
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "accountCell")! as! AccountCell
        cell.accountTitle.text = accounts[indexPath.row].accountName
        cell.accountBlocked.text = "Blocked: " + accounts[indexPath.row].accountBlocked.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editAccountPopup = storyboard?.instantiateViewController(identifier: "editAccountPopup") as? EditAccountPopup {
            // Displaying the edit account popup when an account is clicked
            editAccountPopup.account = accounts[indexPath.row]
            editAccountPopup.presenter = self
            editAccountPopup.modalTransitionStyle = .crossDissolve
            editAccountPopup.modalPresentationStyle = .overCurrentContext
            tableView.deselectRow(at: indexPath, animated: true)
            self.present(editAccountPopup, animated: true, completion: nil)
        }
    }
}
