//
//  LoginScreen.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 19/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit
import AlamofireSoap

class LoginScreen: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
         AlamofireSoap.soapRequest("http://localhost:8080/BrokeringWS/BrokeringWS?WSDL", soapmethod: "ns4:login",
                                   soapparameters: ["arg0":"admin","arg1":"admin"], namespace: "").responseString { response in
            print("Request: \(String(describing: response.request))")   // original url request
                   print("Result: \(response.value)")
           }
         }
      /*AlamofireSoap.soapRequest("http://localhost:8080/BrokeringWS/BrokeringWS?WSDL", soapmethod: "login", soapparameters: ["arg0":"admin","arg1":"admin"], namespace: "http://tempuri.org")*/
    
}
