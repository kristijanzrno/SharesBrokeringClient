//
//  Stock.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import SWXMLHash


// Struct object to resemble SOAP service stock object
// XML mapped to the object using SWXMLHash library

struct Stock: XMLIndexerDeserializable{
    let companyName:String
    let companySymbol:String
    let noOfAvailableShares:Int
    let price: Price?
    let blocked:Bool
    
    static func deserialize(_ element: XMLIndexer) throws -> Stock {
        var price:Price?
        do{
            price = try element["ns4:price"].value()
        }catch{
            print("no price")
        }
        return try Stock(companyName: element["ns4:company_name"].value(), companySymbol: element["ns4:company_symbol"].value(), noOfAvailableShares: element["ns4:no_of_available_shares"].value(), price: price, blocked: element["ns4:blocked"].value()
        )
    }
    
}
