//
//  BoughtShare.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift

class BoughtSharePopup: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var companyNameTV: UILabel!
    @IBOutlet weak var numberOfSharesTV: UILabel!
    @IBOutlet weak var valueTV: UILabel!
    @IBOutlet weak var numberToSellTF: UITextField!
    @IBOutlet weak var toSellValueTV: UILabel!
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    var chosenStock:BoughtStock? = nil
    var stockInfo:Stock? = nil
    var presenter:AccountSharesScreen? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberToSellTF.delegate = self
    }

    func updateUI(){
        companyNameTV.text = chosenStock!.companyName + " - " + chosenStock!.companySymbol
        numberOfSharesTV.text = "Number of shares: " + String(format:"%i", chosenStock!.noOfBoughtShares)
        valueTV.text = "Value: " + (stockInfo?.price!.currency)! + " " + String(format: "%.2f", (Double(chosenStock!.noOfBoughtShares) * (stockInfo?.price!.value)!))
    }
    
    // Getting the stock info and updating the UI with it
    func getStockInfo(xml: XMLIndexer?){
        let info = WSClient().processGetStock(xml: xml)
        if(info != nil){
            self.stockInfo = info
            updateUI()
        }
    }
    
    // Processing the sell request response from the service
    func sellStockHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:sellStockResponse")){
            self.presentingViewController!.view.makeToast("Successfully sold shares!")
            presenter?.viewDidAppear(false)
            
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not sell shares...")
        }
    }
    
    // Sending the sell request to the service
    @IBAction func sellStock(_ sender: Any) {
        WSClient().sellStock(authUsername: authUsername!, authPassword: authPassword!, companySymbol: chosenStock!.companySymbol, amount: numberToSellTF.text!, handler: sellStockHandler)
    }
    
    // Dismissing the window
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Setting the chosen stock before the popup is shown
    func setChosenStock(stock:BoughtStock?, par:AccountSharesScreen){
        self.presenter = par
        chosenStock = stock
        WSClient().getStock(authUsername: authUsername!, authPassword: authPassword!, companySymbol: chosenStock!.companySymbol, currency: currency, handler: getStockInfo)
        
    }
    
    // Updating the sell value as the amount is being written
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var val:Double = 0.0
        if textField.text != ""{
            val = Double(numberToSellTF.text!)!
        }
        toSellValueTV.text = "Sell value: " + stockInfo!.price!.currency + " - " + String(format:"%.2f", (val * (stockInfo?.price!.value)!))
    }
    
    // Allowing only numbers in the text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}
