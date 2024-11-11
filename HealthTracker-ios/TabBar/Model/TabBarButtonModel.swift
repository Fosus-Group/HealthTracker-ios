//
//  TabBarButtonModel.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.10.2024.
//

import UIKit

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
        case .profile: return .Icon.TabBar.person
        case .stats: return .Icon.TabBar.chart
        case .marathon: return .Icon.TabBar.calendar
        case .training: return .Icon.TabBar.drop
        }
    }
}
