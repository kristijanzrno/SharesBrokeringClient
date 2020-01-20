//
//  WSClient.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 19/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import AlamofireSoap
import SWXMLHash

class WSClient {
    
    //var loginHandler: ()->Void
    
    
    func login(authUsername: String, authPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:login", parameters: ["arg0":authUsername,"arg1":authPassword], callback: handler)
    }
    
    func processLogin(xml:XMLIndexer?)->Bool{
        if(xml != nil){
            do{
                let result:Bool = try xml!["S:Envelope"]["S:Body"]["ns2:loginResponse"]["return"].value()
                return result
            }catch{
                print("Could not parse login response...")
            }
        }
        return false
    }
    
    /*func loggedin(xml:XMLIndexer?, loginwait:()->Void)->Bool{
     if(xml != nil){
     do{
     print(xml!["S:Envelope"]["S:Body"]["ns2:loginResponse"]["return"])
     let result:Bool = try xml!["S:Envelope"]["S:Body"]["ns2:loginResponse"]["return"].value()
     
     return result
     }catch{
     print("Could not parse login response...")
     }
     }
     loginwait()
     return false
     }
     
     /*func getAccounts(authUsername: String, authPassword: String) ->[Account]?{
     let xml = sendRequest(method: "ns4:getAccounts", parameters: ["arg0":authUsername,"arg1":authPassword])
     if(xml != nil){
     do{
     let accounts: [Account] = try xml!["S:Envelope"]["S:Body"]["ns2:getAccountsResponse"]["return"].value()
     return accounts
     }catch{
     print("Could not parse accounts...")
     }
     
     }
     return nil
     }
     */*/
    
    
    func sendRequest(method: String, parameters: Dictionary<String, String>, callback:@escaping(XMLIndexer?)->Void){
        var xml:XMLIndexer? = nil
        AlamofireSoap.soapRequest("http://localhost:8080/BrokeringWS/BrokeringWS?WSDL", soapmethod: method,
                                  soapparameters: parameters, namespace: "").responseString { response in
                                    //successful request
                                    xml = SWXMLHash.parse(response.value!)
                                    callback(xml)
                                    
        }
        
    }
    
}
