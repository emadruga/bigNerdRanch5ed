//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Ewerton Madruga on 4/11/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController {
    
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        // create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // figure out where this item is in the array
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            // insert this new row into the table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        if itemStore.allItems.count <= 1 {
            // create a new item and add it to the store
            let lastItem = itemStore.createLastItem("No more items...")
            
            // figure out where this item is in the array
            if let index = itemStore.allItems.indexOf(lastItem) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                
                // insert this new row into the table
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        // if you are currently in editing mode...
        if editing {
            // change text of button to infor user state
            sender.setTitle("Edit", forState: .Normal)
            
            // turn off editing mode
            setEditing(false,animated: true)
        } else {
            // change text button to inform user state
            sender.setTitle("Done", forState: .Normal)
            
            // enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels()
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableView
        let item = itemStore.allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        if item.valueInDollars >= 0 {
            cell.valueLabel.text = "$\(item.valueInDollars)"
            
            if item.valueInDollars > 50 {
                cell.valueLabel.textColor = UIColor.blueColor()
                cell.valueLabel.shadowColor = UIColor.blackColor()
            } else {
                cell.valueLabel.textColor = UIColor.redColor()
                cell.valueLabel.shadowColor = UIColor.blackColor()
            }
            
        } else {
            cell.valueLabel.text = ""
            
            // prevent last cell from being slectable in the table view
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        return cell
    }
    
    func confirmDelete(indexPath: NSIndexPath) {
        let item = itemStore.allItems[indexPath.row]
        
        let title = "Delete \(item.name)?"
        let message = "Are you sure you want to delete this item?"
        
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .Destructive,
                                         handler: { (action) -> Void in
                                            
                                            // remove the item from the store
                                            self.itemStore.removeItem(item)
                                            
                                            // also remove that row from the table view with an animation
                                            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        })
        ac.addAction(deleteAction)
        // present the alert controller
        presentViewController(ac,animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // if the table view is asking to commit a delete command...
        if editingStyle == .Delete {
            confirmDelete(indexPath)
        }
    }
    
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        let last = itemStore.allItems.count - 1
        let proposedLast = proposedDestinationIndexPath.row
        var response = sourceIndexPath
        
        if proposedLast < last {
            response = proposedDestinationIndexPath
        }
        
        return response
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let last = itemStore.allItems.count - 1
        var response = true
        
        if indexPath.row == last {
            response = false
        }
        
        return response
        
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // update the model
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get height of the status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left:0, bottom:0, right:0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            // figure out what row has just been tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController =
                    segue.destinationViewController as! DetailViewController
                detailViewController.item = item
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
}
