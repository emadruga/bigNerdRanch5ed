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

class DetailViewController: UIViewController, UITextFieldDelegate,
                        UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBOutlet var nameField: MyUITextField!
    @IBOutlet var serialNumberField: MyUITextField!
    @IBOutlet var valueField: MyUITextField!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        // if the device has a camera, take a picture; otherwise, 
        // just pick from local library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType    = .PhotoLibrary
            imagePicker.allowsEditing = true
        }
        
        imagePicker.delegate = self
        
        // place image picker on screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
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
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
        
        // get the item key
        let key = item.itemKey
        
        // if there is an associated image with th key
        // display it on the image view
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // store the image in the ImageStore for the imtem's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // put that image on the screen in the image view
        imageView.image = image
        
        // take image picker off the screen - must call the dismiss method
        dismissViewControllerAnimated(true, completion: nil)
    }
}
