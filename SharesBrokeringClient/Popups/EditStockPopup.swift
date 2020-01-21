//
//  EditStockPopup.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 21/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit

class EditStockPopup: UIViewController{
    
    @IBOutlet weak var companyNameTV: UILabel!
    @IBOutlet weak var valueTV: UILabel!
    @IBOutlet weak var lastUpdateTV: UILabel!
    @IBOutlet weak var availableSharesTV: UILabel!
    @IBOutlet weak var blockedTV: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
