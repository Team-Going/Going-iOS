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
        SettingsItem(title: "내 프로필"),
        SettingsItem(title: "모임하기"),
        SettingsItem(title: "서비스 방침"),
        SettingsItem(title: "알림 및 설정"),
        SettingsItem(title: "About doorip"),
        SettingsItem(title: "로그아웃")
    ]
}
