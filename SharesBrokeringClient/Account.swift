//
//  Account.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import SWXMLHash

struct Account: XMLIndexerDeserializable{
       let account_name:String
       let account_password:String
       let account_level:Int
       let account_blocked:Bool
       let bought_shares: [bought_stock]?
       
       static func deserialize(_ element: XMLIndexer) throws -> Account {
           var shares:[bought_stock]?
           do{
               shares = try element["ns3:account_bought_stocks"]["ns3:bought_stock"].value()
           }catch{
               print("no stocks")
           }
           return try Account(account_name: element["ns3:account_name"].value(), account_password: element["ns3:account_password"].value(),
                              account_level: element["ns3:account_level"].value(), account_blocked:element["ns3:blocked" ].value(), bought_shares: shares
           )
       }
       
   }
