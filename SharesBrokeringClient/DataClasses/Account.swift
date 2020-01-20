//
//  Account.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import SWXMLHash

struct Account: XMLIndexerDeserializable{
       let accountName:String
       let accountPassword:String
       let accountLevel:Int
       let accountBlocked:Bool
       let boughtShares: [BoughtStock]?
       
       static func deserialize(_ element: XMLIndexer) throws -> Account {
           var shares:[BoughtStock]?
           do{
               shares = try element["ns3:account_bought_stocks"]["ns3:bought_stock"].value()
           }catch{
               print("no stocks")
           }
           return try Account(accountName: element["ns3:account_name"].value(), accountPassword: element["ns3:account_password"].value(),
                              accountLevel: element["ns3:account_level"].value(), accountBlocked:element["ns3:blocked" ].value(), boughtShares: shares
           )
       }
       
   }
