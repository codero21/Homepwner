//
//  ImageStore.swift
//  Homepwner
//
//  Created by Rollin Francois on 4/18/17.
//  Copyright © 2017 Francois Technology. All rights reserved.
//

import UIKit

class ImageStore {
    
    // MARK: Properties
    
    let cache = NSCache<NSString, UIImage>()
    
    
    // MARK: Action Methods
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create fll URL for image
        let url = imageURL(forKey: key)
        
        // Turn image into JPEG data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            // Write it to full URL
            let _ = try? data.write(to: url, options: [.atomic])
        }
        
    }
    
    func image(forKey key: String) -> UIImage? {
        
        if let existingImage = cache.object(forKey: key as NSString){
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
        
    }
    
    func imageURL(forKey key: String) -> URL {
        
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentsDirectory = documentsDirectories.first!
        
        return documentsDirectory.appendingPathComponent(key)
        
    }
}
