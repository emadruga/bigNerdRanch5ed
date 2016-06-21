//
//  Photo.swift
//  Photorama
//
//  Created by Ewerton Madruga on 6/20/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
