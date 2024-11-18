//
//  DTOConvertible.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import Foundation

protocol DTOConvertible {
    associatedtype DTO: Decodable
    static func fromDTO(_ dto: DTO) -> Self
}
