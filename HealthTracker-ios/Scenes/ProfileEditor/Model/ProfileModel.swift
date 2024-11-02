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
}

extension ProfileModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case username
        case firstName
        case weight
        case height
        case profilePicture
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.height = try container.decode(Double.self, forKey: .height)
        
        if let data = try container.decode(Data?.self, forKey: .profilePicture) {
            guard let image = UIImage(data: data) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .profilePicture,
                    in: container,
                    debugDescription: "Could not decode image"
                )
            }
            self.profilePicture = image
        } else {
            self.profilePicture = nil
        }
    }
}

extension ProfileModel: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(weight, forKey: .weight)
        try container.encode(height, forKey: .height)
        
        let data = profilePicture?.jpegData(compressionQuality: 0)
        try container.encode(data, forKey: .profilePicture)
    }
}
