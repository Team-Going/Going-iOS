//
//  SettingsItem.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/9/24.
//

import UIKit

struct SettingsItem {
    let title: String
}

extension SettingsItem {
    static let settingsDummy: [SettingsItem] = [
        SettingsItem(title: StringLiterals.Settings.myProfile),
        SettingsItem(title: StringLiterals.Settings.inquiry),
        SettingsItem(title: StringLiterals.Settings.serviceVersion),
        SettingsItem(title: StringLiterals.Settings.policy),
        SettingsItem(title: StringLiterals.Settings.privacy),
        SettingsItem(title: StringLiterals.Settings.aboutService),
        SettingsItem(title: StringLiterals.Settings.logout)
    ]
}
