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
class StockPopup: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var companyNameTV: UILabel!
    @IBOutlet weak var valueTV: UILabel!
    @IBOutlet weak var lastUpdatedTV: UILabel!
    @IBOutlet weak var availableSharesTV: UILabel!
    
    @IBOutlet weak var buySharesTF: UITextField!
    @IBOutlet weak var buyValueTV: UILabel!
    
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    var chosenStock:Stock? = nil
    var presenter:MainScreen? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buySharesTF.delegate = self
        updateUI()
    }
    
    func updateUI(){
        companyNameTV.text = chosenStock!.companyName + " - " + chosenStock!.companySymbol
        valueTV.text = "Value: " + (chosenStock?.price!.currency)! + " - " + String(format:"%.2f", (chosenStock?.price!.value)!)
        lastUpdatedTV.text = "Last Updated: " + ((chosenStock?.price?.lastUpdated)?!.dropLast())!
        availableSharesTV.text = "Available: " + String(format:"%i", chosenStock!.noOfAvailableShares)
    }
    
    func setChosenStock(stock:Stock?, par:MainScreen){
        presenter = par
        chosenStock = stock
    }
    
    func buySharesHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:buyStockResponse")){
            self.presentingViewController!.view.makeToast("Successfully bought shares!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not buy shares...")
        }
        
    }
    
    @IBAction func buyShares(_ sender: Any) {
        WSClient().buyStock(authUsername: authUsername!, authPassword: authPassword!, companySymbol: chosenStock!.companySymbol, amount: buySharesTF.text!, handler: buySharesHandler)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let val:Double = Double(buySharesTF.text!)!
        buyValueTV.text = "Purchase value: " + chosenStock!.price!.currency + " - " + String(format:"%.2f", (val * (chosenStock?.price!.value)!))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
