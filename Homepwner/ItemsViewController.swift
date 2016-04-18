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
        if item.valueInDollars < 0 {
            //cell.textLabel?.font = UIFont(name: "System", size: 12.0)
            cell.detailTextLabel?.text = " "
        } else {
            cell.textLabel?.font = UIFont(name: "System", size: 20.0)
            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var cellHeight : CGFloat = 60.0
        
        if (indexPath.row + 1) >= itemStore.allItems.count {
            cellHeight = 44.0
        }
        
        return cellHeight;//Choose your custom row height
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
