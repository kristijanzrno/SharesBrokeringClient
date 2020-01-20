//
//  BoughtStock.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import SWXMLHash

struct BoughtStock: XMLIndexerDeserializable{
     let companyName:String
     let companySymbol:String
     let noOfBoughtShares:Int
     static func deserialize(_ element: XMLIndexer) throws -> BoughtStock {
         return try BoughtStock(companyName: element["ns3:company_name"].value(), companySymbol: element["ns3:company_symbol"].value(), noOfBoughtShares: element["ns3:no_of_bought_shares"].value())
     }
 }
