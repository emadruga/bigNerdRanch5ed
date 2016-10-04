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
        
        store.fetchRecentPhotos()
        
    }
}
