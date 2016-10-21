//
//  PhotosViewController.swift
//  PhotoramaSwift3
//
//  Created by Ewerton Madruga on 10/3/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.dataSource = photoDataSource
        
        store.fetchRecentPhotos(){
            (photosResult) -> Void in
            
            OperationQueue.main.addOperation {
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .Failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.collectionView?.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }
        }
        
    }
}
