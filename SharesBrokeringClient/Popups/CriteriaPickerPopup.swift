//
//  CriteriaPickerPopup.swift
//  SharesBrokeringClient
//
//  Created by Kristijan Zrno on 21/01/2020.
//  Copyright © 2020 Kristijan Zrno. All rights reserved.
//

import UIKit

class CriteriaPickerPopup: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let options:[String] = ["Name - Ascending", "Name - Descending", "Price - Low to High", "Price - High to Low", "Available Shares - Low to High", "Available Shares - High to Low"]
    let xmlOptions:[String] = ["name-asc", "name-desc", "price-lth", "price-htl", "available-shares-lth","available-shares-htl"]
    var presenter:MainScreen? = nil
    var previouslySelected:String = "name-asc"

    var selected:String = ""
    var selectedName:String = ""
    
    
    @IBOutlet weak var criteriaPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.criteriaPicker.delegate = self
              self.criteriaPicker.dataSource = self
        let selectedIndex = xmlOptions.firstIndex(of: previouslySelected)
        criteriaPicker.selectRow(selectedIndex!, inComponent: 0, animated: false)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = xmlOptions[row]
        selectedName = options[row]
    }
    
    @IBAction func pickCriteria(_ sender: Any) {
        presenter?.setSearchCriteria(criteria: selected, criteriaName:selectedName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
