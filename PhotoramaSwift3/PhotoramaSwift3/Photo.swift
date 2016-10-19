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
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
