//
//  ProfileEditorField.swift
//  HealthTracker-ios
//
//  Created by sergey on 02.11.2024.
//

import UIKit

enum ProfileEditorField: CaseIterable {
    case username
    case firstName
    case weight
    case height
    
    
    var title: String {
        switch self {
        case .username:
            CSt.usernameTitledField.title
        case .firstName:
            CSt.firstNameTitledField.title
        case .weight:
            CSt.weightTitledField.title
        case .height:
            CSt.heightTitledField.title
        }
    }
    
    var placeholder: String {
        switch self {
        case .username:
            CSt.usernameTitledField.placeholder
        case .firstName:
            CSt.firstNameTitledField.placeholder
        case .weight:
            CSt.weightTitledField.placeholder
        case .height:
            CSt.heightTitledField.placeholder
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .username, .firstName:
            return .asciiCapable
        case .weight, .height:
            return .decimalPad
        }
    }
    
    var capitalizationType: UITextAutocapitalizationType {
        switch self {
        case .username:
            return .none
        default:
            return .sentences
        }
    }
}
