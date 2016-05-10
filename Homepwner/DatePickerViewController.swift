//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by Helio on 5/9/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var item: Item! {
        didSet {
            navigationItem.title = "Choose Date"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first responder
        view.endEditing(true)
        
        item.dateCreated = datePicker.date
    }

}
