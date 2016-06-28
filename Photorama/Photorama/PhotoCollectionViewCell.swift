//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Ewerton Madruga on 6/24/16.
//  Copyright © 2016 Ewerton Madruga. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
 
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make image content resize to borders of resized cell
        self.contentView.autoresizingMask.insert(.FlexibleHeight)
        self.contentView.autoresizingMask.insert(.FlexibleWidth)
        
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    }
    
}
