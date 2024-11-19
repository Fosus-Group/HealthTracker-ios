//
//  UIImage+PFP.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import UIKit.UIImage

extension UIImage {
    func cacheProfilePicture(withName name: String) -> Data? {
        let filemanager = FileManager.default
        guard let documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let imageURL = documentDirectory.appendingPathComponent(name, conformingTo: .jpeg)
        let data = resize(to: CGSize(width: 100, height: 100))
        
        do {
            try data.write(to: imageURL)
        } catch {
            debugPrint(error)
        }
        
        return data
    }
    
    static func getProfilePicture(withName name: String) -> UIImage? {
        let filemanager = FileManager.default
        guard let documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let imageURL = documentDirectory.appendingPathComponent(name, conformingTo: .jpeg)
            
        if filemanager.fileExists(atPath: imageURL.path) {
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }
    
    func resize(to size: CGSize) -> Data {
        let imageRenderer = UIGraphicsImageRenderer(size: .init(width: 100, height: 100))
        let data = imageRenderer.jpegData(withCompressionQuality: 1) { context in
            let rect = CGRect(origin: .zero, size: .init(width: 100, height: 100))
            self.draw(in: rect)
        }
        
        return data
    }
}
