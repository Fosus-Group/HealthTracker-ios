//
//  ProfileModel.swift
//  HealthTracker-ios
//
//  Created by sergey on 01.11.2024.
//

import UIKit

struct ProfileModel {
    let username: String
    let firstName: String
    let weight: Double
    let height: Double
    let profilePicture: UIImage?
    
    
    func saveToDisk() {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(height, forKey: "height")
        
        
        let filemanager = FileManager.default
        guard let documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        let imageURL = documentDirectory.appendingPathComponent("profilePicture", conformingTo: .jpeg)
        
        guard let profilePicture else { return }
        
        let imageRenderer = UIGraphicsImageRenderer(size: .init(width: 100, height: 100))
        let data = imageRenderer.jpegData(withCompressionQuality: 1) { context in
            let rect = CGRect(origin: .zero, size: .init(width: 100, height: 100))
            profilePicture.draw(in: rect)
        }
        
        do {
            try data.write(to: imageURL)
        } catch {
            debugPrint(error)
        }
        
    }
    
    static func getFromDisk() -> ProfileModel {
        let username = UserDefaults.standard.string(forKey: "username") ?? CSt.defaultUsername
        let firstName = UserDefaults.standard.string(forKey: "firstName") ?? CSt.defaultFirstName
        
        let weight = UserDefaults.standard.double(forKey: "weight")
        let height = UserDefaults.standard.double(forKey: "height")
        
        let filemanager = FileManager.default
        var image: UIImage?
        
        if let documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageURL = documentDirectory.appendingPathComponent("profilePicture", conformingTo: .jpeg)
            
            if filemanager.fileExists(atPath: imageURL.path) {
                image = UIImage(contentsOfFile: imageURL.path)
            }
        }
        
        return ProfileModel(
            username: username,
            firstName: firstName,
            weight: weight,
            height: height,
            profilePicture: image
        )
    }
}
