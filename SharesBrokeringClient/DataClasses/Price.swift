//
//  Price.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 20/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import SWXMLHash

struct Price: XMLIndexerDeserializable{
    let currency:String
    let value:Double
    let lastUpdated:String?
    
    static func deserialize(_ element: XMLIndexer) throws -> Price {
        return try Price(currency: element["ns4:currency"].value(), value: element["ns4:value"].value(), lastUpdated: element["ns4:last_updated"].value()
        )
    }
    
}
