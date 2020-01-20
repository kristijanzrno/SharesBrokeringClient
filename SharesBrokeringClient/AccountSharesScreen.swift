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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
              self.tableView.dataSource = self
              self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadUserData()
        fetchData()
    }
    func fetchDataHandler(xml: XMLIndexer?){
          let fetchedStocks = WSClient().processAllAccountShares(xml: xml)
          if(fetchedStocks != nil){
              boughtStocks.removeAll()
              boughtStocks.append(contentsOf: fetchedStocks!)
              self.tableView.reloadData()
          }
      }
      
      func fetchData(){
        WSClient().getAllAccountShares(authUsername: authUsername ?? "", authPassword: authPassword ?? "", handler: fetchDataHandler)
      }
      
      func reloadUserData(){
          currency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
          authUsername = UserDefaults.standard.string(forKey: "username")
          authPassword = UserDefaults.standard.string(forKey: "password")
      }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return boughtStocks.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
          cell.textLabel!.text = boughtStocks[indexPath.row].companySymbol
          return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print(indexPath.row)
      }

}

