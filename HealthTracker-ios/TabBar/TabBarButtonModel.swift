//
//  TabBarButtonModel.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.10.2024.
//

import UIKit

struct TabBarButtonModel {
    let title: String
    let image: UIImage?
}


enum TabBarButton: Int, CaseIterable {
    case profile
    case stats
    case marathon
    case training
    
    var title: String {
        switch self {
        case .profile: return "Профиль"
        case .stats: return "Статистика"
        case .marathon: return "Марафон"
        case .training: return "Тренировка"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .profile: return .Icon.tabBarPerson
        case .stats: return .Icon.tabBarChart
        case .marathon: return .Icon.tabBarCalendar
        case .training: return .Icon.tabBarDrop
        }
    }
}
