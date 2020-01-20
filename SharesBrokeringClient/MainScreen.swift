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

    var currency:String = "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    var stocks:[Stock] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        fetchData()
    }
    

    func fetchDataHandler(xml: XMLIndexer?){
        let fetchedStocks = WSClient().processAllStocks(xml: xml)
        if(fetchedStocks != nil){
            stocks.removeAll()
            stocks.append(contentsOf: fetchedStocks!)
            self.tableView.reloadData()
        }
    }
    
    func fetchData(){
        WSClient().getAllStocks(authUsername: authUsername ?? "", authPassword: authPassword ?? "", currency: "USD" ?? "", handler: fetchDataHandler)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel!.text = stocks[indexPath.row].companySymbol
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    

}

