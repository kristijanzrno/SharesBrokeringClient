//
//  SecondViewController.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 19/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash

class AccountSharesScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    var boughtStocks:[BoughtStock] = []
    
    var accountBalance:Double = 0.0
    
    @IBOutlet weak var accountBalanceTV: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("reload")
        reloadUserData()
        fetchData()
    }
    
    // Processing the fetched data
    func fetchDataHandler(xml: XMLIndexer?){
        let fetchedStocks = WSClient().processAllAccountShares(xml: xml)
        if(fetchedStocks != nil){
            boughtStocks.removeAll()
            boughtStocks.append(contentsOf: fetchedStocks!)
            self.tableView.reloadData()
        }
        accountBalance = 0.0
        for boughtShare in boughtStocks{
            WSClient().getStock(authUsername: authUsername!, authPassword: authPassword!, companySymbol: boughtShare.companySymbol, currency: currency, handler: getStockInfo)
        }
        
    }
    
    // Getting the stock info for every stock owned by the account
    // To find out the total balance of the account
    func getStockInfo(xml: XMLIndexer?){
        let info = WSClient().processGetStock(xml: xml)
        if(info != nil){
            for boughtShare in boughtStocks{
                if boughtShare.companyName == info?.companyName{
                    accountBalance = accountBalance + (Double(boughtShare.noOfBoughtShares) * (info?.price!.value)!)
                    accountBalanceTV.text = "Account Balance: " + currency + String(format:"%.2f", accountBalance)
                    break
                }
            }
        }
    }
    
    // Fetching the all account shares
    func fetchData(){
        WSClient().getAllAccountShares(authUsername: authUsername ?? "", authPassword: authPassword ?? "", handler: fetchDataHandler)
    }
    
    // Reloading the user data
    func reloadUserData(){
        currency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
        authUsername = UserDefaults.standard.string(forKey: "username")
        authPassword = UserDefaults.standard.string(forKey: "password")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boughtStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setting the custom tableview cell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myShareCell")! as! MyShareCell
        cell.stockTitle.text = boughtStocks[indexPath.row].companyName
        cell.stockSymbol.text = boughtStocks[indexPath.row].companySymbol
        cell.boughtShares.text = String(format:"%i", boughtStocks[indexPath.row].noOfBoughtShares) + " Shares"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let boughtSharePopup = storyboard?.instantiateViewController(identifier: "boughtSharePopup") as? BoughtSharePopup {
            // Invoking the share info popup when its clicked
            boughtSharePopup.setChosenStock(stock: boughtStocks[indexPath.row], par: self)
            boughtSharePopup.modalTransitionStyle = .crossDissolve
            boughtSharePopup.modalPresentationStyle = .overFullScreen
            tableView.deselectRow(at: indexPath, animated: true)
            self.present(boughtSharePopup, animated: true, completion: nil)
        }
    }
    
}

