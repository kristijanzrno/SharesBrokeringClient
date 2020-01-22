//
//  StockPopup.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift
class StockPopup: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var companyNameTV: UILabel!
    @IBOutlet weak var valueTV: UILabel!
    @IBOutlet weak var lastUpdatedTV: UILabel!
    @IBOutlet weak var availableSharesTV: UILabel!
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var buySharesTF: UITextField!
    @IBOutlet weak var buyValueTV: UILabel!
    
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    var chosenStock:Stock? = nil
    var presenter:MainScreen? = nil
    
    var news:[Articles] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buySharesTF.delegate = self
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        updateUI()
    }
    
    // Function to assign the stock values to the UI
    func updateUI(){
        companyNameTV.text = chosenStock!.companyName + " (" + chosenStock!.companySymbol + ")"
        valueTV.text = "Value: (" + (chosenStock?.price!.currency)! + ") " + String(format:"%.2f", (chosenStock?.price!.value)!)
        lastUpdatedTV.text = "Updated: " + ((chosenStock?.price?.lastUpdated)?!.dropLast())!
        availableSharesTV.text = "Available: " + String(format:"%i", chosenStock!.noOfAvailableShares)
        fetchNews()
    }
    
    // Setting the chosen stock object from the main screen
    func setChosenStock(stock:Stock?, par:MainScreen){
        presenter = par
        chosenStock = stock
    }
    
    // Processing the buy share response
    func buySharesHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:buyStockResponse")){
            self.presentingViewController!.view.makeToast("Successfully bought shares!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not buy shares...")
        }
    }
    
    // Sending the buy share request to the service
    @IBAction func buyShares(_ sender: Any) {
        WSClient().buyStock(authUsername: authUsername!, authPassword: authPassword!, companySymbol: chosenStock!.companySymbol, amount: buySharesTF.text!, handler: buySharesHandler)
    }
    
    // Dismissing the window
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Fetching the news from an external API
    func fetchNews(){
        let url=URL(string:"https://newsapi.org/v2/everything?q=" + chosenStock!.companySymbol + "&apiKey=7e4d79a7707c443588f0323628bd180d")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            do{
                let json = try JSONDecoder().decode(NewsBase.self, from: data!)
                self.news.removeAll()
                self.news.append(contentsOf: json.articles ?? [])
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            }catch{
                print("error")
            }
        }
        task.resume()
    }
    
    // Updating the "purchase value" text view when the "to buy" amount is changed
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var val:Double = 0.0
        if textField.text != ""{
            val = Double(buySharesTF.text!)!
        }
        buyValueTV.text = "Purchase value: (" + chosenStock!.price!.currency + ") " + String(format:"%.2f", (val * (chosenStock?.price!.value)!))
    }
    
    // Allowing only numbers in the amount text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating the custom news item cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell")! as! NewsCell
        cell.newsTitle.text = news[indexPath.row].title
        cell.newsDescription.text = news[indexPath.row].description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: news[indexPath.row].url!) else { return }
        UIApplication.shared.open(url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
