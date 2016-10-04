//
//  PhotoStore.swift
//  PhotoramaSwift3
//
//  Created by Ewerton Madruga on 10/4/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class PhotoStore {
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos() {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data,response,error) -> Void in
            
            if let jsonData = data {
                if let jsonString = NSString(data: jsonData,
                                             encoding: String.Encoding.utf8.rawValue) {
                    print(jsonString)
                }
            }
            else if let requestError = error {
                print("Error fetching recent photos: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            }            
        }
        task.resume()
    }
}
