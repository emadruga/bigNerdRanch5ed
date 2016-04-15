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
    
    init() {
        let len = arc4random_uniform(5)
        for _ in 0..<len {
            createItem()
        }
        let noLabelItem = Item(name: "No more items!", serialNumber: "???", valueInDollars: -1)
        allItems.append(noLabelItem)
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
    
        return newItem
    }
}

