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
    
    @IBOutlet weak var selectedLabel: UILabel!
    
    func coolDateFormat(displayDate : NSDate) -> String {
        var response : String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        //dateFormatter.timeStyle = .MediumStyle
        response = dateFormatter.stringFromDate(displayDate)

        
        return response
    }
    @IBAction func datePickerAction(sender: AnyObject) {

        self.selectedLabel.text = coolDateFormat(datePicker.date)
    }
    
    var item: Item! {
        didSet {
            navigationItem.title = "Choose Date"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.dateCreated = datePicker.date
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectedLabel.text = coolDateFormat(item.dateCreated)
        
        datePicker.date         = item.dateCreated
    }
    
}
