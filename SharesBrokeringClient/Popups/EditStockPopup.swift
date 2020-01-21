//
//  EditStockPopup.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 21/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash
import Toast_Swift

class EditStockPopup: UIViewController{
    
    @IBOutlet weak var companyNameTV: UILabel!
    @IBOutlet weak var valueTV: UILabel!
    @IBOutlet weak var lastUpdateTV: UILabel!
    @IBOutlet weak var availableSharesTV: UILabel!
    @IBOutlet weak var blockedTV: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    
    var chosenStock:Stock? = nil
    var presenter:AdminStocksScreen? = nil
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        companyNameTV.text = chosenStock!.companyName + " - " + chosenStock!.companySymbol
        valueTV.text = "Value: " + (chosenStock?.price!.currency)! + " - " + String(format:"%.2f", (chosenStock?.price!.value)!)
        lastUpdateTV.text = "Last Updated: " + ((chosenStock?.price?.lastUpdated)?!.dropLast())!
        availableSharesTV.text = "Available: " + String(format:"%i", chosenStock!.noOfAvailableShares)
        blockedTV.text = "Blocked: " + (chosenStock?.blocked.description)!
        if chosenStock!.blocked{
            blockButton.titleLabel?.text = "Unblock"
        }
    }
    
    func toggleBlockHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:changeStockAccessResponse")){
            self.presentingViewController!.view.makeToast("Successfully changed stock access mode!")
            presenter?.viewDidAppear(false)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.makeToast("Could not change stock access mode...")
        }
    }
    
    @IBAction func toggleBlock(_ sender: Any) {
        let blocked = !(chosenStock!.blocked)
        WSClient().changeStockAccess(authUsername: authUsername!, authPassword: authPassword!, companySymbol: chosenStock!.companySymbol, blocked: blocked.description, handler: toggleBlockHandler)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
