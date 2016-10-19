//
//  PhotosViewController.swift
//  PhotoramaSwift3
//
//  Created by Ewerton Madruga on 10/3/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos(){
            (photosResult) -> Void in
            
            switch photosResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) recent photos.")
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(photo: firstPhoto){
                        (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .Success(image):
                            OperationQueue.main.addOperation {
                                self.imageView.image = image
                            }
                        case let .Failure(error):
                            print("Error downloading image: \(error)")
                        }
                    }
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
        
    }
}
