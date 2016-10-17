//
//  Photo.swift
//  PhotoramaSwift3
//
//  Created by Ewerton Madruga on 17/10/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import Foundation

class Photo {
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
