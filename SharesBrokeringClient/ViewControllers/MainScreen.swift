//
//  FirstViewController.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 19/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash

class MainScreen: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var stocks:[Stock] = []
    var searchCriteria:String = "name-asc"
    var searchCriteriaName:String = "Name - Ascending"
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var criteriaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // Processing the fetched data
    func fetchDataHandler(xml: XMLIndexer?){
        var fetchedStocks:[Stock]? = nil
        if(searchTF.text == "" && searchCriteria == "name-asc"){
            fetchedStocks = WSClient().processAllStocks(xml: xml)
        }else{
            fetchedStocks = WSClient().processSearchStocks(xml: xml)
        }
        if(fetchedStocks != nil){
            stocks.removeAll()
            stocks.append(contentsOf: fetchedStocks!)
            self.tableView.reloadData()
        }
    }
    
    // Reloading the data each time the view re-appears
    override func viewDidAppear(_ animated: Bool) {
        reloadUserData()
        fetchData()
        criteriaButton.setTitle(searchCriteriaName, for: .normal)
    }
    
    // Fetching the data from the core WS
    func fetchData(){
        if(searchTF.text == "" && searchCriteria == "name-asc"){
            WSClient().getAllStocks(authUsername: authUsername ?? "", authPassword: authPassword ?? "", currency: currency, handler: fetchDataHandler)
        }else{
            WSClient().searchStocks(authUsername: authUsername!, authPassword: authPassword!, searchFor: searchTF.text!, orderBy: searchCriteria, currency: currency, handler: fetchDataHandler)
        }
    }
    // Reloading the user data (e.g. in case of password or currency change)
    func reloadUserData(){
        currency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
        authUsername = UserDefaults.standard.string(forKey: "username")
        authPassword = UserDefaults.standard.string(forKey: "password")
    }
    
    // Sending the search request
    @IBAction func search(_ sender: Any) {
        fetchData()
    }
    
    // Setting the search criteria from the "order by" popup
    func setSearchCriteria(criteria:String, criteriaName:String){
        self.searchCriteria = criteria
        self.searchCriteriaName = criteriaName
        criteriaButton.setTitle(searchCriteriaName, for: .normal)
    }
    
    // Invoking the "order by" popup
    @IBAction func changeCriteria(_ sender: Any) {
        if let criteriaPickerPopup = storyboard?.instantiateViewController(identifier: "criteriaPickerPopup") as? CriteriaPickerPopup {
            criteriaPickerPopup.presenter = self
            criteriaPickerPopup.previouslySelected = searchCriteria
            criteriaPickerPopup.modalTransitionStyle = .crossDissolve
            criteriaPickerPopup.modalPresentationStyle = .overCurrentContext
            self.present(criteriaPickerPopup, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setting the custom tableview cell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "stockCell")! as! StockCell
        cell.stockTitle!.text = stocks[indexPath.row].companyName
        cell.stockSymbol!.text = stocks[indexPath.row].companySymbol
        cell.stockPrice!.text = stocks[indexPath.row].price!.currency + String(format:"%.2f", stocks[indexPath.row].price!.value)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Invoking the stock popup when a stock item has been picked
        if let stockPopup = storyboard?.instantiateViewController(identifier: "stockPopup") as? StockPopup {
            stockPopup.setChosenStock(stock: stocks[indexPath.row], par:self)
            stockPopup.modalTransitionStyle = .crossDissolve
            stockPopup.modalPresentationStyle = .overCurrentContext
            tableView.deselectRow(at: indexPath, animated: true)
            self.present(stockPopup, animated: true, completion: nil)
        }
        
    }
    
    
    
    
}

