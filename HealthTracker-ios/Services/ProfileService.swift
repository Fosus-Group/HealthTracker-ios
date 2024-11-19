//
//  ProfileService.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import UIKit.UIImage

protocol ProfileServiceProtocol {
    func loadProfile() async throws -> ProfileModel
    func loadImage(hex: String) async throws -> UIImage
    
    func updateProfile(_ profile: ProfileModel) async throws -> ProfileModel
}

struct ProfileService: ProfileServiceProtocol {
    
    enum ImageError: Error {
        case corruptedData
    }
    
    private let networking: NetworkingServiceProtocol
    
    init(networking: NetworkingServiceProtocol) {
        self.networking = networking
    }
    
    func loadProfile() async throws -> ProfileModel {
        let api = API.userMe
        let result = try await networking.makeRequest(api: api, of: ProfileModel.DTO.self)
        
        let profile = ProfileModel.fromDTO(result)
        
        if let hex = result.avatarHex {
            if let image = try? await loadImage(hex: hex) {
                return profile.withImage(image)
            }
        }
        
        return profile
    }
    
    func loadImage(hex: String) async throws -> UIImage {
        let string = "https://storage.yandexcloud.net/health.storage/health.storage/" + hex
        let url = URL(string: string)!
        let apiRequest = API.Request.get(url: url)
        let data = try await networking.makeRequest(apiRequest: apiRequest, allowRetry: true)
        
        if let image = UIImage(data: data) {
            return image
        } else {
            throw ImageError.corruptedData
        }
    }
    
    func updateProfile(_ profile: ProfileModel) async throws -> ProfileModel {
        let api = API.userUpdate(profile.username, profile.height)
        
        let result = try await networking.makeRequest(api: api, of: ProfileModel.DTO.self)
        
        return ProfileModel.fromDTO(result)
    }
    
    func updateImage(_ image: Data) async throws -> Bool {
        let api = API.userUpload(image)
        
        let result = try await networking.makeRequest(api: api, of: [String: Bool].self)
        
        return result["success"] ?? false
    }
}
