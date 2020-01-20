//
//  BoughtStock.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import SWXMLHash

struct bought_stock: XMLIndexerDeserializable{
     let company_name:String
     let company_symbol:String
     let no_of_bought_shares:Int
     static func deserialize(_ element: XMLIndexer) throws -> bought_stock {
         return try bought_stock(company_name: element["ns3:company_name"].value(), company_symbol: element["ns3:company_symbol"].value(), no_of_bought_shares: element["ns3:no_of_bought_shares"].value())
     }
 }
