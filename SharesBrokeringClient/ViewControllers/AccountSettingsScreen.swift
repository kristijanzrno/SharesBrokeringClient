//
//  AccountSettingsScreen.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 19/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import SWXMLHash

class AccountSettingsScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currency:String = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var authUsername:String? = UserDefaults.standard.string(forKey: "username")
    var authPassword:String? = UserDefaults.standard.string(forKey: "password")
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var adminButton: UIButton!
    
    
    var currencyList:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadUserData()
        fetchData()
        usernameTF.text = authUsername
        
    }
    
    func fetchDataHandler(xml: XMLIndexer?){
        let fetchedCurrencies = WSClient().processCurrencyList(xml: xml)
        if(fetchedCurrencies != nil){
            currencyList.removeAll()
            currencyList.append(contentsOf: fetchedCurrencies!)
            self.currencyPicker.reloadComponent(0)
        }
        for code in currencyList{
            if code.starts(with: currency){
                print(code)
                currencyPicker.selectRow(currencyList.firstIndex(of: code)!, inComponent: 0, animated: false)
            }
        }
    }
    
    func isAdminHandler(xml: XMLIndexer?){
        if(WSClient().getBoolResponse(xml: xml, methodName: "ns2:isAdminResponse")){
            adminButton.isHidden = false
        }else{
            adminButton.isHidden = true
        }
    }
    
    func fetchData(){
        WSClient().getCurrencyList(authUsername: authUsername ?? "", authPassword: authPassword ?? "", handler: fetchDataHandler)
        WSClient().getIsAdmin(authUsername: authUsername!, authPassword: authPassword!, handler: isAdminHandler)
    }
    
    func reloadUserData(){
        currency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
        authUsername = UserDefaults.standard.string(forKey: "username")
        authPassword = UserDefaults.standard.string(forKey: "password")
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if let changePasswordPopup = storyboard?.instantiateViewController(identifier: "changePasswordPopup") as? ChangePasswordPopup{
            self.present(changePasswordPopup, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.set("USD", forKey: "currency")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func adminUtilities(_ sender: Any) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = currencyList[row]
        UserDefaults.standard.set(currency.split(separator:" ")[0], forKey: "currency")
    }
}
