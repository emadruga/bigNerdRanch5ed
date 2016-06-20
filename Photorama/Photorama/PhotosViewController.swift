//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Ewerton Madruga on 6/20/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class PhotosViewController : UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos()
    }
}
