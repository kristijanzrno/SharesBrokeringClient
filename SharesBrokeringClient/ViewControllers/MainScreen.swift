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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func setSearchCriteria(criteria:String, criteriaName:String){
        self.searchCriteria = criteria
        self.searchCriteriaName = criteriaName
        criteriaButton.setTitle(searchCriteriaName, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel!.text = stocks[indexPath.row].companySymbol
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let stockPopup = storyboard?.instantiateViewController(identifier: "stockPopup") as? StockPopup {
            stockPopup.setChosenStock(stock: stocks[indexPath.row], par:self)
            stockPopup.modalTransitionStyle = .crossDissolve
            stockPopup.modalPresentationStyle = .overCurrentContext
            self.present(stockPopup, animated: true, completion: nil)
        }

    }
    
    @IBAction func search(_ sender: Any) {
        fetchData()
    }
    

    @IBAction func changeCriteria(_ sender: Any) {
        if let criteriaPickerPopup = storyboard?.instantiateViewController(identifier: "criteriaPickerPopup") as? CriteriaPickerPopup {
                   criteriaPickerPopup.presenter = self
                   criteriaPickerPopup.previouslySelected = searchCriteria
                   criteriaPickerPopup.modalTransitionStyle = .crossDissolve
                   criteriaPickerPopup.modalPresentationStyle = .overCurrentContext
            self.present(criteriaPickerPopup, animated: true, completion: nil)
                   
               }
    }
}

