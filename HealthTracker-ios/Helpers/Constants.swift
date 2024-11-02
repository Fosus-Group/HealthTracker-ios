//
//  Constants.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit.UIFont

typealias CSp = Constants.Spacing
typealias CSt = Constants.Strings
typealias CFs = Constants.Fonts

enum Constants {
    
    static let baseDeviceSize = CGSize(width: 390, height: 844)
    
    enum Spacing {
        static let min: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
        static let xlarge: CGFloat = 64
        
        static func multiply4(by value: Int) -> CGFloat {
            return 4 * CGFloat(value)
        }
    }
    
    enum Strings {
        // MARK: Auth
        static let onboardingTitle = "Вход/Регистрация"
        static let onboardignCaption = "Здоровье - это процесс, а не мгновенный результат"
        static let buttonStart = "Начать"
        static let buttonLogin = "Войти"
        static let phoneTextfieldText = "Введите номер своего телефона"
        static let verifyPhoneTitle = "Сейчас вам поступит звонок, введите последние 4 цифры входящего номера"
        static let refreshCallText = "Получить новый код можно через"
        static let requestNewCodeText = "Запросить новый код"
        
        // MARK: Profile
        static let profileGreetingText = "Привет"
        static let editProfileButtonText = "Редактировать профиль"
        
        static let waterCardTitle = "ВОДА"
        static let waterCardText = "Вода необходима для нормального функционирования организма."
        static let followCardTitle = "СЛЕДУЙ"
        static let followCardText = "Регулярные тренировки гораздо эффективнее, чем случайные."
        static let bodyCardTitle = "ТЕЛО"
        static let bodyCardText = "Если ты чувствуешь боль, не игнорируй ее. Отдыхай и восстанавливайся, когда нужно."
        
        static let saveText = "СОХРАНИТЬ"
    }
    
    enum Fonts {
        static let button: UIFont = .systemFont(ofSize: 25, weight: .bold)
        static let body: UIFont = .systemFont(ofSize: 12, weight: .bold)
        static let text: UIFont = .systemFont(ofSize: 16, weight: .bold)
    }
    
    static let authButtonHeight: CGFloat = 58
    static let authCodeHeight: CGFloat = 56
    
    static let carouselWaterCard = CarouselCellModel(
        title: Strings.waterCardTitle,
        body: Strings.waterCardText,
        image: .Pictures.waterCard
    )
    static let carouselFollowCard = CarouselCellModel(
        title: Strings.followCardTitle,
        body: Strings.followCardText,
        image: .Pictures.followCard
    )
    static let carouselBodyCard = CarouselCellModel(
        title: Strings.bodyCardTitle,
        body: Strings.bodyCardText,
        image: .Pictures.bodyCard
    )
}
