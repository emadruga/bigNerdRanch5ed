//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Helio on 5/4/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class MyUITextField: UITextField {
    var origStyle = UITextBorderStyle.RoundedRect
    
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        if becomeFirstResponder {
            self.origStyle   = self.borderStyle
            self.borderStyle = .Line
        }
        return becomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        if resignFirstResponder {
            self.borderStyle = .RoundedRect
        }
        return resignFirstResponder
    }

}

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBOutlet var nameField: MyUITextField!
    @IBOutlet var serialNumberField: MyUITextField!
    @IBOutlet var valueField: MyUITextField!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        //valueField.text = "\(item.valueInDollars)"
        //dateLabel.text = "\(item.dateCreated)"
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first responder
        view.endEditing(true)
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
                value = numberFormatter.numberFromString(valueText) {
            item.valueInDollars = value.integerValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if the triggered segue is the "ShowItem" segue
        if segue.identifier == "ItemDatePicker" {
            // figure out what row has just been tapped
            let datePickerViewController =
                    segue.destinationViewController as! DatePickerViewController
            datePickerViewController.item = item
            
        }
    }
}


