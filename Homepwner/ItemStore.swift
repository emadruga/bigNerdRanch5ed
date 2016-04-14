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
    var hiItems = [Item]()
    var loItems = [Item]()
    
    init() {
        for _ in 0..<10 {
            createItem()
        }
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        if newItem.valueInDollars >= 50 {
            hiItems.append(newItem)
        } else if newItem.valueInDollars < 15 {
            loItems.append(newItem)
        } else {
            allItems.append(newItem)
        }
    return newItem
    }
    
    func getItem(indexPath: NSIndexPath) -> Item {
        var response : Item
        if indexPath.section == 0 {
            response = hiItems[indexPath.row]
        } else if indexPath.section == 1 {
            response = allItems[indexPath.row]
        } else {
            response = loItems[indexPath.row]
        }
        return response
    }
}

