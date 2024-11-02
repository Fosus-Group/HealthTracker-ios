//
//  UserDefaults.swift
//  HealthTracker-ios
//
//  Created by sergey on 02.11.2024.
//

import Foundation

extension UserDefaults {
    enum ProfileModelError: Error {
        case noData
    }
    
    func saveProfileModel(_ model: ProfileModel) -> Result<Void, Error> {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: "profileModel")
            return .success(Void())
        } catch {
            return .failure(error)
        }
    }
    
    func getProfileModel() -> Result<ProfileModel, Error> {
        guard let data = UserDefaults.standard.data(forKey: "profileModel") else {
            return .failure(ProfileModelError.noData)
        }
        do {
            let decoder = JSONDecoder()
            let profileModel = try decoder.decode(ProfileModel.self, from: data)
            return .success(profileModel)
        } catch {
            return .failure(error)
        }
    }
}
