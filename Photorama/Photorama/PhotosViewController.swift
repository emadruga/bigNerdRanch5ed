//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Ewerton Madruga on 6/20/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit


class PhotosViewController : UIViewController, UICollectionViewDelegate {
    //@IBOutlet var imageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    // number of photo images per row in collection view
    let numberOfItemsPerRow = 3
    
    var currentCellSize = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .Failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // download the image data, which could take some time
        store.fetchImageForPhoto(photo) { (result) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                // the index path for the photo might have changed between 
                // the request started and finished, so find the most 
                // recent index path
                
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath)
                                                                as? PhotoCollectionViewCell {
                    if let imageView = cell.imageView {
                        imageView.contentMode = .ScaleAspectFill
                        //imageView.contentMode = .ScaleToFill
                    }

                    cell.updateWithImage(photo.image)
                }
            }
        }
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        currentCellSize = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: currentCellSize, height: currentCellSize)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC =
                    segue.destinationViewController as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        }
    }
}
