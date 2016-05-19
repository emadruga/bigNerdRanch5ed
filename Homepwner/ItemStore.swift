//
//  ItemStore.swift
//  Homepwner
//
//  Created by Ewerton Madruga on 4/11/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    let itemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
        
    func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        
        if allItems.count > 2 {
                let last = allItems.count - 1
                let secondToLast = last - 1
            
                // swap items to make sure "no more items" is always last...
                let tmp = allItems[last]
                allItems[last] = allItems[secondToLast]
                allItems[secondToLast] = tmp
        
        }
    
        return newItem
    }
    
    func createLastItem(itemName: String) -> Item {
        let newItem = Item(name: itemName, serialNumber: nil, valueInDollars: -1)
        allItems.append(newItem)
        
        return newItem
    }
    
    
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // remove item from array
        allItems.removeAtIndex(fromIndex)
        
        // insert item in array at new location
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    func saveChanges() -> Bool {
        print ("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
}

