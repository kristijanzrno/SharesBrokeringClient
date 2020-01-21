//
//  AdminStocksScreen.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 21/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift

class AdminStocksScreen: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    
    var searchCriteria:String = "name-asc"
    var searchCriteriaName:String = "Name - Ascending"
    
    var stocks:[Stock] = []
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var criteriaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        reloadUserData()
        fetchData()
        criteriaButton.setTitle(searchCriteriaName, for: .normal)
        
    }
    
    func fetchData(){
        if(searchTF.text == "" && searchCriteria == "name-asc"){
            WSClient().getAllStocks(authUsername: authUsername ?? "", authPassword: authPassword ?? "", currency: currency, handler: fetchDataHandler)
        }else{
            WSClient().searchStocks(authUsername: authUsername!, authPassword: authPassword!, searchFor: searchTF.text!, orderBy: searchCriteria, currency: currency, handler: fetchDataHandler)
        }
    }
    func reloadUserData(){
        currency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
        authUsername = UserDefaults.standard.string(forKey: "username")
        authPassword = UserDefaults.standard.string(forKey: "password")
    }
    
    @IBAction func search(_ sender: Any) {
          fetchData()
      }
    
    @IBAction func changeCriteria(_ sender: Any) {
        if let criteriaPickerPopup = storyboard?.instantiateViewController(identifier: "criteriaPickerPopup") as? CriteriaPickerPopup {
                         criteriaPickerPopup.adminPresenter = self
                         criteriaPickerPopup.previouslySelected = searchCriteria
                         criteriaPickerPopup.modalTransitionStyle = .crossDissolve
                         criteriaPickerPopup.modalPresentationStyle = .overCurrentContext
                  self.present(criteriaPickerPopup, animated: true, completion: nil)
                         
    }
    }
    
        func setSearchCriteria(criteria:String, criteriaName:String){
               self.searchCriteria = criteria
               self.searchCriteriaName = criteriaName
               criteriaButton.setTitle(searchCriteriaName, for: .normal)
           }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "stockCell")! as! StockCell
        cell.stockTitle!.text = stocks[indexPath.row].companyName
        cell.stockSymbol!.text = stocks[indexPath.row].companySymbol
        cell.stockPrice!.text = stocks[indexPath.row].price!.currency + String(format:"%.2f", stocks[indexPath.row].price!.value)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editStockPopup = storyboard?.instantiateViewController(identifier: "editStockPopup") as? EditStockPopup {
            editStockPopup.chosenStock = stocks[indexPath.row]
            editStockPopup.presenter = self
            editStockPopup.modalTransitionStyle = .crossDissolve
            editStockPopup.modalPresentationStyle = .overCurrentContext
            tableView.deselectRow(at: indexPath, animated: true)
            self.present(editStockPopup, animated: true, completion: nil)
        }
    }
    
}





