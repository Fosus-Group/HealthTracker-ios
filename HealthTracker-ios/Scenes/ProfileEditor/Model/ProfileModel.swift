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
    let height: Int
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
        let height = UserDefaults.standard.integer(forKey: "height")
        
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

struct ProfileModelDTO {
    let phoneNumber: String?
    let username: String?
    let avatarHex: String?
    let height: Int?
}

extension ProfileModelDTO: Decodable {
    enum CodingKeys: CodingKey {
        case phoneNumber
        case username
        case avatarHex
        case height
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.phoneNumber = try container.decode(Optional<String>.self, forKey: .phoneNumber)
        self.username = try container.decode(Optional<String>.self, forKey: .username)
        self.avatarHex = try container.decode(Optional<String>.self, forKey: .avatarHex)
        self.height = try container.decode(Optional<Int>.self, forKey: .height)
    }
}

extension ProfileModel: DTOConvertible {
    typealias DTO = ProfileModelDTO
    
    static func fromDTO(_ dto: DTO) -> ProfileModel {
        Self(
            phoneNumber: dto.phoneNumber ?? "",
            username: dto.username ?? "",
            firstName: "",
            weight: 0,
            height: dto.height ?? 0,
            profilePicture: nil
        )
    }
    
    func toDTO() -> DTO {
        DTO(
            phoneNumber: phoneNumber,
            username: username,
            avatarHex: nil,
            height: height
        )
    }
}
