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
    
    
    func getAccounts(authUsername: String, authPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:getAccounts", parameters: ["arg0":authUsername,"arg1":authPassword], callback: handler)
    }
    
    func processAccounts(xml: XMLIndexer?) ->[Account]?{
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
    
    func createAccount(accountUsername: String, accountPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:createAccount", parameters: ["arg0":"admin","arg1":"admin", "arg2":accountUsername, "arg3":accountPassword, "arg4":"1"], callback: handler)
    }
    func processCreateAccount(xml:XMLIndexer?)->Bool{
        if(xml != nil){
                   do{
                       let result:Bool = try xml!["S:Envelope"]["S:Body"]["ns2:createAccountResponse"]["return"].value()
                       return result
                   }catch{
                       print("Could not parse account creation response...")
                   }
               }
               return false
    }
    
    func getAllStocks(authUsername: String, authPassword: String, currency: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:getAllStocks", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":currency], callback: handler)
    }
    
    func processAllStocks(xml:XMLIndexer?)->[Stock]?{
        if(xml != nil){
                  do{
                      let stocks: [Stock] = try xml!["S:Envelope"]["S:Body"]["ns2:getAllStocksResponse"]["return"].value()
                      return stocks
                  }catch{
                      print("Could not parse stocks...")
                  }
              }
              return nil
    }
    
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
