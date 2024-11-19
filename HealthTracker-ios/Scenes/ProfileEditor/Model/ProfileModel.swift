//
//  ProfileModel.swift
//  HealthTracker-ios
//
//  Created by sergey on 01.11.2024.
//

import UIKit

struct ProfileModel {
    let phoneNumber: String
    let username: String
    let firstName: String
    let weight: Double
    let height: Double
    let profilePicture: UIImage?
}

extension ProfileModel {
    func saveToDisk() -> Data? {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(height, forKey: "height")
        
        return profilePicture?.cacheProfilePicture(withName: "profilePicture")
    }
    
    static func getFromDisk() -> ProfileModel {
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? CSt.defaultPhoneNumber
        let username = UserDefaults.standard.string(forKey: "username") ?? CSt.defaultUsername
        let firstName = UserDefaults.standard.string(forKey: "firstName") ?? CSt.defaultFirstName
        
        let weight = UserDefaults.standard.double(forKey: "weight")
        let height = UserDefaults.standard.double(forKey: "height")
        
        let image: UIImage? = .getProfilePicture(withName: "profilePicture")
        
        return ProfileModel(
            phoneNumber: phoneNumber,
            username: username,
            firstName: firstName,
            weight: weight,
            height: height,
            profilePicture: image
        )
    }
}

extension ProfileModel {
    func withImage(_ image: UIImage) -> Self {
        Self(
            phoneNumber: phoneNumber,
            username: username,
            firstName: firstName,
            weight: weight,
            height: height,
            profilePicture: image
        )
    }
}

struct ProfileModelDTO: Decodable {
    let phoneNumber: String?
    let username: String?
    let avatarHex: String?
    let height: Double?
}

extension ProfileModel: DTOConvertible {
    typealias DTO = ProfileModelDTO
    
    static func fromDTO(_ dto: DTO) -> ProfileModel {
        Self(
            phoneNumber: dto.phoneNumber ?? "",
            username: dto.username ?? "",
            firstName: CSt.defaultFirstName,
            weight: 0,
            height: dto.height ?? 0,
            profilePicture: nil
        )
    }
}
