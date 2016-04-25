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
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableView
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // if the table view is asking to commit a delete command...
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            
            // remove the item from the store
            itemStore.removeItem(item)
            
            // also remove that row from the table view with an animation
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
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
    }
    
}
