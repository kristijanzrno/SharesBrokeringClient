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
    
    // Processing Login requests
    func login(authUsername: String, authPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:login", parameters: ["arg0":authUsername,"arg1":authPassword], callback: handler)
    }
    
    func getBoolResponse(xml:XMLIndexer?, methodName:String)->Bool{
        if(xml != nil){
            do{
                let result:Bool = try xml!["S:Envelope"]["S:Body"][methodName]["return"].value()
                return result
            }catch{
                print("Could not parse bool...")
            }
        }
        return false
    }
    
    // Processing Get Accounts requests
    
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
    
    // Processing account creation requests
    func createAccount(accountUsername: String, accountPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:createAccount", parameters: ["arg0":"admin","arg1":"admin", "arg2":accountUsername, "arg3":accountPassword, "arg4":"1"], callback: handler)
    }
    
    // Processing get all stocks requests
    
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
    
    // Processing get stock requests
    
    func getStock(authUsername: String, authPassword: String, companySymbol:String, currency: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:getStock", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":companySymbol, "arg3":currency], callback: handler)
    }
    
    func processGetStock(xml:XMLIndexer?)->Stock?{
        if(xml != nil){
            do{
                let stock: Stock = try xml!["S:Envelope"]["S:Body"]["ns2:getStockResponse"]["return"].value()
                return stock
            }catch{
                print("Could not parse stock...")
            }
        }
        return nil
    }
    
    // Processing buy stock request
    func buyStock(authUsername: String, authPassword: String, companySymbol:String, amount: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:buyStock", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":companySymbol, "arg3":amount], callback: handler)
    }
    
    //Processing sell stock requests
    func sellStock(authUsername: String, authPassword: String, companySymbol:String, amount: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:sellStock", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":companySymbol, "arg3":amount], callback: handler)
    }
    
    //Processing account deletion
    func deleteAccount(authUsername: String, authPassword: String, accountName:String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:deleteAccount", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":accountName], callback: handler)
    }
    
    //Processing account deletion
    func getAllAccountShares(authUsername: String, authPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:getAllAccountShares", parameters: ["arg0":authUsername,"arg1":authPassword], callback: handler)
    }
    
    func processAllAccountShares(xml: XMLIndexer?) ->[BoughtStock]?{
        if(xml != nil){
            do{
                let boughtStocks: [BoughtStock] = try xml!["S:Envelope"]["S:Body"]["ns2:getAllAccountSharesResponse"]["return"].value()
                return boughtStocks
            }catch{
                print("Could not parse accounts...")
            }
        }
        return nil
    }
    
    //Processing stock acces change
    func changeStockAccess(authUsername: String, authPassword: String,
                           companySymbol: String, blocked:String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:changeStockAccess", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":companySymbol, "arg3":blocked], callback: handler)
    }
    
    //Processing account access change
    func changeAccountAccess(authUsername: String, authPassword: String,
                             accountName: String, blocked:String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:changeAccountAccess", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":accountName, "arg3":blocked], callback: handler)
    }
    
        
    //Processing getting account currency list
    
    func getCurrencyList(authUsername: String, authPassword: String, handler:@escaping(XMLIndexer?)->Void){
        sendRequest(method: "ns4:getCurrencyList", parameters: ["arg0":authUsername,"arg1":authPassword], callback: handler)
    }
    
    
    
    func processCurrencyList(xml: XMLIndexer?) ->[String]?{
        if(xml != nil){
            do{
                let currencyList: [String] = try xml!["S:Envelope"]["S:Body"]["ns2:getCurrencyListResponse"]["return"].value()
                return currencyList
            }catch{
                print("Could not parse accounts...")
            }
        }
        return nil
    }
    
    // Change account password
           func changeAccountPassword(authUsername: String, authPassword: String,
                                newPassword: String, handler:@escaping(XMLIndexer?)->Void){
           sendRequest(method: "ns4:changeAccountPassword", parameters: ["arg0":authUsername,"arg1":authPassword, "arg2":newPassword], callback: handler)
       }
    
    
    // Sending Requests
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
